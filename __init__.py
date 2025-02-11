from homeassistant import config_entries
from .const import DOMAIN

async def async_setup(hass, config):
    """Set up the add-on."""
    return True

async def async_setup_entry(hass, entry):
    """Set up the add-on from a config entry."""
    return True

async def async_unload_entry(hass, entry):
    """Unload the add-on."""
    return True