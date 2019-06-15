from powerline.theme import requires_segment_info
from os.path import exists

_SSHUTTLE_SYMBOL = u'\U0001f680 '

@requires_segment_info
def status(pl, segment_info):
    pl.debug('Running sshuttle.status')
    try:
        pid_path = segment_info['environ'].get("SSHUTTLE_PID_PATH", '/tmp/sshuttle-office.pid')
        if exists(pid_path):
            return [{
                'contents': _SSHUTTLE_SYMBOL + u'running',
                'highlight_groups': ['warning:regular'],
            }]
        else:
            return [{
                'contents': _SSHUTTLE_SYMBOL + u'stopped',
                'highlight_groups': ['information:regular'],
            }]
    except Exception as e:
        pl.error("error: {}".format(e))
