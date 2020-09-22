import sys

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import HasFocus, ViInsertMode
from prompt_toolkit.key_binding.vi_state import InputMode, ViState

ip = get_ipython()


###############################
#  Set jk to exit input mode  #
###############################


def switch_to_navigation_mode(event):
    event.cli.vi_state.input_mode = InputMode.NAVIGATION


if getattr(ip, "pt_app", None):
    ip.pt_app.key_bindings.add_binding(
        u"j", u"k", filter=(HasFocus(DEFAULT_BUFFER) & ViInsertMode())
    )(switch_to_navigation_mode)


############################################
#  Change cursor shape in navigation mode  #
############################################


def get_input_mode(self):
    return self._input_mode


def set_input_mode(self, mode):
    shape = {InputMode.NAVIGATION: 1, InputMode.REPLACE: 3}.get(mode, 5)
    raw = u"\x1b[{} q".format(shape)
    if hasattr(sys.stdout, "_cli"):
        out = sys.stdout._cli.output.write_raw
    else:
        out = sys.stdout.write
    out(raw)
    sys.stdout.flush()
    self._input_mode = mode


ViState._input_mode = InputMode.INSERT
ViState.input_mode = property(get_input_mode, set_input_mode)
