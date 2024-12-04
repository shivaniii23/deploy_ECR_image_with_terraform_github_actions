const express = require("express");
const app = express();

app.get("/", (req, res) => {
    res.send("up and running");
});

app.listen(8081, () => {
    console.log("server is up");
});
