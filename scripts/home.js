const name = localStorage.getItem("name");
const address = localStorage.getItem("address");

const chairs = localStorage.getItem("chairs");
const tables = localStorage.getItem("tables");
const tents = localStorage.getItem("tents");

const dateBorrowed = localStorage.getItem("dateBorrowed");
const dateReturned = localStorage.getItem("dateReturned");

const validID = localStorage.getItem("validID");

document.getElementById("borrowerName").textContent = name;

document.getElementById("borrowerAddress").textContent = address;

document.getElementById("borrowerChairs").textContent = chairs;

document.getElementById("borrowerTables").textContent = tables || "0";

document.getElementById("borrowerTents").textContent = tents || "0";

document.getElementById("dateBorrowed").textContent = dateBorrowed;

document.getElementById("dateReturned").textContent = dateReturned;

document.getElementById("validID").textContent = validID;