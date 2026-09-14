 

    const borrowerData = JSON.parse(
        localStorage.getItem("borrowerData")
    );

    if (borrowerData) {

        document.getElementById("borrowerName").textContent =
            borrowerData.name;

        document.getElementById("borrowerAddress").textContent =
            borrowerData.address;

        document.getElementById("borrowerChairs").textContent =
            borrowerData.chairs;

        document.getElementById("borrowerTables").textContent =
            borrowerData.tables || "0";

        document.getElementById("borrowerTents").textContent =
            borrowerData.tents || "0";

        document.getElementById("dateBorrowed").textContent =
            borrowerData.dateBorrowed;

        document.getElementById("dateReturned").textContent =
            borrowerData.dateReturned;

        document.getElementById("validID").textContent =
            borrowerData.validIDFileName;

    }
