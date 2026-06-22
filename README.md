HP Laptop 17-cp2xxx (board 8DC5) ships with an AMD ACP6x digital
microphone.

The Linux acp6x-mach driver exits early when the ACPI DMIC status
reports disabled.

This prevents the driver from checking the DMI quirk table, making
the internal microphone unavailable.

# FIX:

Replace:

    return -ENODEV;

with:

    goto check_dmi_entry;

and add a DMI entry:

    HP
    8DC5

This allows the driver to continue into the quirk lookup path and
register the ACP6x DMIC device correctly.

# HARDWARE

HP Laptop 17-cp2xxx
Board: 8DC5
Audio: AMD ACP6x + ALC236
Kernel: 7.0.0-22-generic
