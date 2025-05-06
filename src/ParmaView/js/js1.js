function getVersion() {
    fetch("/cgi-bin/version.sh")
        .then(function(response) {
            return response.text();
        })
        .then(function(text) {
            document.getElementById("version").textContent = text.trim();
        })
        .catch(err => {
            console.warn("Could not connect:", err.message);
        });
}
function getBlockHeight() {
    fetch("/cgi-bin/blockheight.sh")
        .then(function(response) {
            return response.text();
        })
        .then(function(text) {
            document.getElementById("blockheight").textContent = text.trim();
        })
        .catch(err => {
            console.warn("NA:", err.message);
        });
}

/*Clarke Moodey Dashboard*/
const ws = new WebSocket("wss://bitcoin.clarkmoody.com/dashboard/ws");
ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    if (data.type === "price" && data.pair === "BTC/USD") {
      priceEl.textContent = "$" + Number(data.value).toLocaleString();
    }
  };

  ws.onerror = (err) => {
    priceEl.textContent = "1 bitcoin";
    console.error(err);
  };