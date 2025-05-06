function getVersion() {
    fetch("/cgi-bin/version.sh")
        .then(function(response) {
            return response.text();
        })
        .then(function(text) {
            document.getElementById("version").textContent = text;
        });
}
