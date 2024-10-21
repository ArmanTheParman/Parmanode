function clearup_chain {

#block 865,000
please_wait
echo -e "Invalidating block 865,000. Can take several minutes..."
bitcoin-cli invalidateblock 000000000000000000018b745cc38c17456b15a0f5a1cec5a4ebe1227bf5467c
echo -e "Process complete. Now reconsidering block 865,000..."
bitcoin-cli invalidateblock 000000000000000000018b745cc38c17456b15a0f5a1cec5a4ebe1227bf5467c
echo -e "Process complete. Blockchain should be syncing again from block 865,000 onwards."
echo ""
echo "You can watch the log file for progress"
enter_continue
}