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
            console.warn("NA");
        });
}
function getBitcoinPrice() {
    fetch("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd")
        .then(res => res.json())
        .then(data => {
            const price = "$" + data.bitcoin.usd.toLocaleString();
            showPriceCycle(price);
        })
        .catch(err => {
            console.warn("NA");
        });
}

function showPriceCycle(priceText) {
    const el = document.getElementById("price");
    
    el.textContent = priceText;
    
    setTimeout(() => {
        el.textContent = "1 bitcoin";
    }, 5000); // After 5 seconds, show "1 bitcoin"

    setTimeout(() => {
        getBitcoinPrice(); // Repeat cycle
    }, 7500); // After total 7.5 seconds, fetch again
}

// Start the cycle
getBitcoinPrice();
