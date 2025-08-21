"""Entry point for the nozzle cleaning fan control extension."""

from .prtouch_v2_fan import PRTouchFan


def load_config(config):
  """Register the fan control helper with Klipper."""
  return PRTouchFan(config)
