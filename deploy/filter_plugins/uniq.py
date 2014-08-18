def _uniq(seq):
    ''' Order preserving unique function'''
    seen = set()
    return [x for x in seq if x not in seen and not seen.add(x)]

class FilterModule (object):
    def filters(self):
        return {
            "uniq": _uniq
        }
