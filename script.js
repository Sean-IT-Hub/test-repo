const form = document.querySelector(".form-index");

form.addEventListener("submit", function(event) {

    const dateBorrowed = document.getElementById("dateBorrowed").value;
    const dateReturned = document.getElementById("dateReturned").value;

    const chairs = document.getElementById("chairs").value;
    const tables = document.getElementById("tables").value;
    const tents = document.getElementById("tents").value;

    const validID = document.getElementById("validID").files.length;

    if (Number(chairs) === 0 && Number(tables) === 0 && Number(tents) === 0) {
        event.preventDefault();
        alert("Please select at least minimum of the Items.");
        return;
    }

    if (new Date(dateReturned) <= new Date(dateBorrowed)) {
        event.preventDefault();
        alert("The return date must be later than the borrowed date.");
        return;
    }

    if (validID === 0) {
        event.preventDefault();
        alert("Please upload a valid ID with signature.");
        return;
    }

    const confirmSubmit = confirm(
        "Are you sure you want to submit your borrower slip?"
    );

    if (!confirmSubmit) {
        event.preventDefault();
    }

});