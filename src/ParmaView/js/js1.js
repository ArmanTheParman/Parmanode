let socket = new WebSocket("ws://" + location.host + "/ws/");

socket.onmessage = function(event) {
    console.log("Received:", event.data);
    const title = document.getElementById("title");
    const original = title.textContent;
    title.textContent = event.data;
    setTimeout(() => {
        title.textContent = original;
    }, 3000);
};

function getVersion() {
    fetch("/cgi-bin/version.sh");
}