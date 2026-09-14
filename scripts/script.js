const form = document.querySelector(".form-index");

form.addEventListener("submit", function (event) {

    const name = document.getElementById("f-name").value;
    const address = document.getElementById("address").value;

    const chairs = document.getElementById("chairs").value;
    const tables = document.getElementById("tables").value;
    const tents = document.getElementById("tents").value;

    const dateBorrowed = document.getElementById("dateBorrowed").value;
    const dateReturned = document.getElementById("dateReturned").value;

    const validIDFile = document.getElementById("validID").files[0];

    if (!validIDFile) {
        event.preventDefault();
        alert("Please upload a valid ID with signature.");
        return;
    }

    if (new Date(dateReturned) <= new Date(dateBorrowed)) {
        event.preventDefault();
        alert("The return date must be later than the borrowed date.");
        return;
    }

    const confirmSubmit = confirm(
        "Are you sure you want to submit your borrower slip?"
    );

    if (!confirmSubmit) {
        event.preventDefault();
        return;
    }

    const borrowerData = {
        name: name,
        address: address,
        chairs: chairs,
        tables: tables,
        tents: tents,
        dateBorrowed: dateBorrowed,
        dateReturned: dateReturned,
        validIDFileName: validIDFile.name
    };

    localStorage.setItem(
        "borrowerData",
        JSON.stringify(borrowerData)
    );

});