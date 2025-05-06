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
    fetch("/cgi-bin/bitcoinprice.sh")
        .then(res => res.json())
        .then(data => {
            const price = "$" + data.bitcoin.usd.toLocaleString();
            showPriceCycle(price);
        })
        .catch(err => {
            console.warn("NA");
            showPriceCycle("1 bitcoin");
        });
}

function showPriceCycle(priceText) {
    const el = document.getElementById("price");

    el.textContent = priceText;

    setTimeout(() => {
        el.textContent = "1 bitcoin";
    }, 5000); // Show "1 bitcoin" after 5 sec

    setTimeout(() => {
        getBitcoinPrice(); // Restart cycle after 7.5 sec
    }, 7500);
}

// Start the loop
getBitcoinPrice();
