#! /usr/bin/env python
import json
import requests
from requests.auth import HTTPBasicAuth
from itertools import chain
from logging import getLogger, StreamHandler, DEBUG, INFO
import calendar
import datetime
import dateutil.parser
import pandas as pd
import numpy as np
from optparse import OptionParser

logger = getLogger(__name__)
handler = StreamHandler()
logger.addHandler(handler)
logger.propagate = False
logger.setLevel(INFO)

def extract(xs={}, keys=[]):
    ret = {}
    for key in keys:
        ret[key] = xs[key]
    return ret

class Toggl:
    def __init__(self, email, api_key, toggl_api_path="https://www.toggl.com/api/v8", toggl_report_api_path="https://toggl.com/reports/api/v2"):
      self.email = email
      self.api_key = api_key
      self.auth = HTTPBasicAuth(self.api_key,'api_token')
      self.toggl_api_path = toggl_api_path
      self.toggl_report_api_path = toggl_report_api_path

    def get_workspaces(self):
        response = self.toggl_get_request("/workspaces")
        workspaces = json.loads(response.text)
        return [extract(w, ['id', 'name']) for w in workspaces]

    def get_clients_of(self, workspace_id):
        response = self.toggl_get_request("/workspaces/%d/clients" % workspace_id)
        clients = json.loads(response.text)
        return [extract(c, ['id', 'wid', 'name']) for c in clients]

    def get_projects_of(self, client_id):
        response = self.toggl_get_request("/clients/%d/projects" % client_id)
        projects = json.loads(response.text)
        return [extract(p, ['id', 'wid', 'cid', 'name']) for p in projects]

    def get_users_of(self, workspace_id):
        response = self.toggl_get_request("/workspaces/%d/workspace_users" % workspace_id)
        ws_users = json.loads(response.text)
        return [extract(u, ['uid', 'name']) for u in ws_users]

    def get_detailed_report_of(self, workspace_id, client_ids, project_ids, user_ids, start_date, end_date):
        timers = []
        for pn in range(1000):
            params = {
                'user_agent': self.email,
                'workspace_id': workspace_id,
                'client_ids': ",".join(map(str,client_ids)),
                'project_ids': ",".join(map(str,project_ids)),
                'user_ids': ",".join(map(str,user_ids)),
                'page': pn,
                'since': start_date,
                'until': end_date,
                'order_filed': 'date',
                'order_desc': 'off',
                'per_page': 100
            }
            logger.debug(params)
            response = self.report_get_request("/details", params)
            data = json.loads(response.text)['data']
            if len(data) == 0:
                break
            else:
                timers.extend(data)
        return timers

    def toggl_get_request(self, path, params = {}):
        response = requests.get(self.toggl_api_path + path, auth=self.auth, params = params)
        logger.debug(response.text)
        return response

    def report_get_request(self, path, params = {}):
        response = requests.get(self.toggl_report_api_path + path, auth=self.auth, params = params)
        logger.debug(response.text)
        return response

def choose_items_from(xs, title, stringify):
    print title
    for i, x in enumerate(xs):
        print "[%d] %s" % (i, stringify(x))
    ns = map(int, raw_input("Choose(0): ").split() or [0])
    return [xs[n] for n in ns]

def main():
    parser = OptionParser(usage="%prog -k API_KEY -e EMAIL [-s since_date] [-u until_date]", version="%prog 0.1")
    parser.add_option("-k", "--api-key", dest="api_key", help="api key", metavar="API_KEY")
    parser.add_option("-e", "--email", dest="email", help="email")
    parser.add_option("-s","--since", dest="since", help="since(YYYY-MM-DD)")
    parser.add_option("-u","--until", dest="until", help="until(YYYY-MM-DD)")
    (options, args) = parser.parse_args()
    if not options.api_key:
        parser.error('--api-key not given')
    if not options.email:
        parser.error('--email not given')

    logger.debug(options)

    toggl = Toggl(options.email, options.api_key)

    workspaces = choose_items_from(
        toggl.get_workspaces(),
        "-- Choose Workspace --",
        lambda x: "%s (%d)" % (x["name"], x["id"])
    )
    workspace_ids = [ ws["id"] for ws in workspaces]
    logger.debug(workspaces)

    clients = choose_items_from(
        list(chain.from_iterable(
            [toggl.get_clients_of(wid) for wid in workspace_ids]
        )),
        "-- Choose Clients --",
        lambda x: "%s (%d)" % (x["name"], x["id"])
    )
    client_ids = [ c["id"] for c in clients]
    logger.debug(clients)

    projects = map(lambda x: x[1], choose_items_from(
        list(chain.from_iterable(
         [[ (c["name"], p)
            for p in toggl.get_projects_of(c["id"]) ]
            for c in clients ]
        )),
        "-- Choose Projects --",
        lambda x: "%s: %s (%d)" % (x[0], x[1]["name"], x[1]["id"])
    ))
    project_ids = [p["id"] for p in projects]
    logger.debug(projects)

    users = map(lambda x: x[1], choose_items_from(
        list(chain.from_iterable(
         [[ (ws["name"], u)
            for u in toggl.get_users_of(ws["id"]) ]
            for ws in workspaces ]
        )),
        "-- Choose Users --",
        lambda x: "%s: %s (%d)" % (x[1]["name"], x[0], x[1]["uid"])
    ))
    user_ids = [u["uid"] for u in users]
    logger.debug(users)

    today = datetime.date.today()
    monthrange = calendar.monthrange(today.year,today.month)
    default_sdate = "%04d-%02d-01" % (today.year, today.month)
    default_edate = "%04d-%02d-%02d" % (today.year, today.month, monthrange[1])
    sdate = options.since or (raw_input("start date(%s): " % default_sdate) or default_sdate)
    edate = options.until or (raw_input("  end date(%s): " % default_edate) or default_edate)

    timers = list(chain.from_iterable([toggl.get_detailed_report_of(wid, client_ids, project_ids, user_ids, sdate, edate) for wid in workspace_ids]))

    def comp_timer(t1, t2):
        s1 = dateutil.parser.parse(t1["start"])
        s2 = dateutil.parser.parse(t2["start"])
        if s1 < s2:
            return -1
        elif s1 == s2:
            return 0
        else:
            return 1

    timers = sorted(timers, comp_timer)
    for t in timers:
        t["date"] = dateutil.parser.parse(t["start"]).date()
        t["start"] = dateutil.parser.parse(t["start"])
        t["end"] = dateutil.parser.parse(t["end"])

    logger.debug(timers)
    logger.debug([ t["start"] for t in timers])

    df = pd.DataFrame(timers)
    df = df.groupby('date').agg({'start': [np.min], 'end':[np.max]})

    print ""
    print "date,day of week, start,end"
    for index, row in df.iterrows():
        print "%s,%s,%s,%s" % (index, calendar.day_name[index.weekday()], str(row["start"]["amin"].replace(second=0).time()), str(row["end"]["amax"].replace(second=0).time()))

if __name__ == '__main__':
  main()
