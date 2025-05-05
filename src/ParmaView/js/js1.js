let socket = new WebSocket("ws://localhost:58001");

socket.onmessage = function(event) {
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
