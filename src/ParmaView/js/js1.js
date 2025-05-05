let socket = new WebSocket("ws://" + location.host + "/ws/");

socket.onmessage = function(event) {
    const title = document.getElementById("title");
    const original = title.textContent;
    title.textContent = event.data;
    setTimeout(() => {
        title.textContent = original;
    }, 3000);
};
function getVersion() {
    fetch("/cgi-bin/version.sh")
        .then(res => {
            console.log("CGI triggered:", res.status);
            return res.text();
        })
        .then(text => console.log("Response body:", text))
        .catch(err => console.error("CGI fetch error:", err));
}
