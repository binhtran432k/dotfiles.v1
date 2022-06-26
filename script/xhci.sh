#!/bin/sh
# 
# This script should prevent the following suspend errors
#  which freezes the Dell Inspiron laptop. 
#
# Put it in /usr/lib/systemd/system-sleep/xhci.sh
#
# The PCI 00:14.0 device is the usb xhci controller.
#
#    kernel: [67445.560610] pci_pm_suspend(): hcd_pci_suspend+0x0/0x30 returns -16
#    kernel: [67445.560619] dpm_run_callback(): pci_pm_suspend+0x0/0x150 returns -16
#    kernel: [67445.560624] PM: Device 0000:00:14.0 failed to suspend async: error -16
#    kernel: [67445.886961] PM: Some devices failed to suspend, or early wake event detected

if [ "${1}" == "pre" ]; then
  # Do the thing you want before suspend here, e.g.:
  echo "Disable broken xhci module before suspending at $(date)..." > /tmp/systemd_suspend_test
  grep GLAN.*enable /proc/acpi/wakeup && echo GLAN > /proc/acpi/wakeup
  grep EHC1.*enable /proc/acpi/wakeup && echo EHC1 > /proc/acpi/wakeup
  grep EHC2.*enable /proc/acpi/wakeup && echo EHC2 > /proc/acpi/wakeup
  grep XHC.*enable /proc/acpi/wakeup && echo XHC > /proc/acpi/wakeup
elif [ "${1}" == "post" ]; then
  # Do the thing you want after resume here, e.g.:
  echo "Enable broken xhci module at wakeup from $(date)" >> /tmp/systemd_suspend_test
  grep GLAN.*disable /proc/acpi/wakeup && echo GLAN > /proc/acpi/wakeup
  grep EHC1.*disable /proc/acpi/wakeup && echo EHC1 > /proc/acpi/wakeup
  grep EHC2.*disable /proc/acpi/wakeup && echo EHC2 > /proc/acpi/wakeup
  grep XHC.*disable /proc/acpi/wakeup && echo XHC > /proc/acpi/wakeup
fi
