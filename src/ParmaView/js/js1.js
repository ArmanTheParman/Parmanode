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
