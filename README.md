# MP_Vmspawn

A vehicle spawning resource for **FiveM** servers running **QBX Core**. Players with permission can use `/vmspawn <model>` to spawn a vehicle and automatically apply the configured upgrades.

## Features

- Spawns vehicles by their GTA/FiveM model name.
- Checks that the requested model is a valid vehicle.
- Waits for the model to load, with a 10-second timeout.
- Optionally deletes the vehicle the player is currently driving before spawning.
- Optionally spawns the vehicle in front of the player.
- Optionally places the player in the driver seat.
- Applies configurable engine, transmission, brake, armour, suspension and turbo upgrades.
- Supports QBX permission groups and a citizen ID allowlist.
- Prints successful and failed spawn attempts to the server console.

## Requirements

- FiveM server
- `qbx_core`
- `ox_lib`

Ensure `ox_lib` and `qbx_core` are started before this resource.

## Installation

1. Extract the `MP_Vmspawn` folder into your server's resources directory.
2. Open `MP_Vmspawn/shared/config.lua` and configure permissions and spawn settings.
3. Add the resource to your `server.cfg`:

   ```cfg
   ensure ox_lib
   ensure qbx_core
   ensure MP_Vmspawn
   ```

4. Restart the server or start the resource.

## Usage

In-game, run:

```text
/vmspawn <vehicle_model>
```

Example:

```text
/vmspawn adder
```

Use the vehicle's spawn/model name, not its display name.

## Configuration

All settings are in `shared/config.lua`.

### Permission settings

```lua
Config.PermissionMode = 'citizen'
Config.PermissionGroup = 'admin'

Config.AllowedCitizens = {
    ['xxxxxxxx'] = true,
}
```

`Config.PermissionMode` supports:

| Mode | Access rule |
|---|---|
| `group` | Player must meet `Config.PermissionGroup`. |
| `citizen` | Player's citizen ID must be enabled in `Config.AllowedCitizens`. |
| `both` | Player can pass either the group check **or** the citizen ID check. |

Available group levels are `mod`, `admin` and `god`. Higher levels satisfy lower-level requirements. For example, a `god` player passes an `admin` requirement.

Replace `xxxxxxxx` with the actual QBX citizen ID. Add one entry per permitted player:

```lua
Config.AllowedCitizens = {
    ['ABC12345'] = true,
    ['XYZ67890'] = true,
}
```

Set an entry to `false` or remove it to revoke allowlist access.

**Important — ACE permission:** The command is registered as a restricted FiveM command (`RegisterCommand(..., true)`). The player must also have the relevant ACE permission in addition to passing the resource's QBX permission check. For example, grant it to a suitable ACE group in `server.cfg`:

```cfg
add_ace group.admin command.vmspawn allow
```

Make sure the ACE group assignment matches your server's permission setup. The QBX group check and FiveM ACE check are separate.

### Spawn settings

```lua
Config.SpawnInFront = false
Config.SpawnOffset = 6.0
Config.WarpIntoSeat = true
Config.DeletePrevious = true
```

- `SpawnInFront`: spawn the vehicle in front of the player's current position.
- `SpawnOffset`: distance in metres when `SpawnInFront` is enabled.
- `WarpIntoSeat`: put the player in the driver's seat after spawning.
- `DeletePrevious`: delete the vehicle the player is currently inside before spawning.

### Vehicle upgrades

```lua
Config.Upgrades = {
    Engine       = true,
    Transmission = true,
    Brakes       = true,
    Armour       = true,
    Suspension   = false,
    Turbo        = true,
}
```

Each option enables or disables that upgrade for every spawned vehicle. The resource selects the highest available mod level for engine, transmission, brakes, armour and suspension. Turbo is toggled on when enabled.
