let socket = new WebSocket("ws://" + location.host + "/ws/");

socket.onmessage = function(event) {
    const title = document.getElementById("title");
    const original = title.textContent;
    title.textContent = event.data;
};

function getVersion() {
    fetch("/cgi-bin/version.sh");
}