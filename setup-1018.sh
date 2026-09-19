#!/bin/bash
# HP LaserJet 1018 setup. Run after: sudo ./install.sh
# Firmware is sent automatically with every print job.
PPD=/Library/Printers/PPDs/Contents/Resources/HP-LaserJet_1018.ppd
DIR=/Library/Printers/printer-all
FILTER=/usr/libexec/cups/filter/rastertozjs-1018fw

URI=$(lpinfo -v | grep -i "1018" | awk '{print $2}' | head -1)
if [ -z "$URI" ]; then
  echo "Printer not found. Switch it on, connect the USB cable and run this again."
  exit 1
fi

# Firmware copy where the print system is allowed to read it
sudo mkdir -p "$DIR"
sudo cp /usr/local/share/foo2zjs/firmware/sihp1018.dl "$DIR/" || exit 1

# Wrapper: send firmware, then run the real driver
sudo tee "$FILTER" >/dev/null <<'WRAP'
#!/bin/sh
cat /Library/Printers/printer-all/sihp1018.dl || exit 1
exec /usr/libexec/cups/filter/rastertozjs "$@"
WRAP
sudo chown root:wheel "$FILTER"
sudo chmod 755 "$FILTER"

# Printer queue
sudo lpadmin -x HP_LaserJet_1018 2>/dev/null
sudo lpadmin -p HP_LaserJet_1018 -E -v "$URI" -P "$PPD" || exit 1
sudo lpadmin -d HP_LaserJet_1018

echo
echo "Done!"
