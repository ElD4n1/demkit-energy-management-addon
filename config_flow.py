import os
import voluptuous as vol
from homeassistant import config_entries
from homeassistant.core import callback

from .const import DOMAIN

@callback
def configured_instances(hass):
    """Return a set of configured instances."""
    return set(entry.data['directory_path'] for entry in hass.config_entries.async_entries(DOMAIN))

class ExampleConfigFlow(config_entries.ConfigFlow, domain=DOMAIN):
    """Handle a config flow for Example."""

    VERSION = 1
    CONNECTION_CLASS = config_entries.CONN_CLASS_LOCAL_PUSH

    async def async_step_user(self, user_input=None):
        """Handle the initial step."""
        errors = {}
        if user_input is not None:
            if user_input['directory_path'] in configured_instances(self.hass):
                errors['base'] = 'path_exists'
            else:
                # Write environment variables to a file in the home/config folder
                config_path = os.path.join(os.path.expanduser("~"), "config", "env_vars.sh")
                with open(config_path, 'w') as env_file:
                    env_file.write(f"export DEMKIT_FOLDER={user_input['folder_name']}\n")
                    env_file.write(f"export DEMKIT_MODEL={user_input['model_name']}\n")
                    env_file.write(f"export DEMKIT_COMPONENTS={user_input['directory_path']}\n")

                return self.async_create_entry(title=user_input['directory_path'], data=user_input)

        data_schema = vol.Schema({
            vol.Required('directory_path'): str,
            vol.Required('model_name'): str,
            vol.Required('folder_name'): str,
        })

        return self.async_show_form(
            step_id='user', data_schema=data_schema, errors=errors
        )