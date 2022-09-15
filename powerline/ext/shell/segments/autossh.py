from powerline.theme import requires_segment_info
import os
import glob 
import re

_AUTOSSH_SYMBOL = u'\U0001f680 '

@requires_segment_info
def status(pl, segment_info, pidfiledir=u'/tmp', pidfileptn=u'autossh-(.*).pid'):
    pl.debug('Running sshuttle.status')
    active = [ re.match(pidfileptn, os.path.basename(f)).groups()[0] for f in glob.glob(pidfiledir+u'/*') if re.match(pidfileptn, os.path.basename(f)) ]
    ret = [{
        'contents': _AUTOSSH_SYMBOL + u'stopped',
        'highlight_groups': ['information:regular'],
    }]
    if len(active) > 0:
        ret = [{
            'contents': _AUTOSSH_SYMBOL + u','.join(active),
            'highlight_groups': ['warning:regular'],
        }]
    return ret
