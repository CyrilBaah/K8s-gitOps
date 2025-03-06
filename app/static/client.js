console.log('We are inside client.js');

const btn = document.getElementById('submit');
if (btn) {
    btn.addEventListener('click', func);
}

function func() {
    const planet_id = document.getElementById("planetID").value;
    console.log("onClick Submit - Request Planet ID - " + planet_id);

    fetch("/planet", {
            method: "POST",
            body: JSON.stringify({ id: planet_id }),
            headers: {
                "Content-type": "application/json; charset=UTF-8"
            }
        })
        .then(function(res) {
            if (res.ok) {
                return res.json();
            }
            throw new Error('Request failed.');
        }).catch(function(error) {
            alert("Ooops, We have 8 planets.\nSelect a number from 0 - 8");
            console.log(error);
        })
        .then(function(data) {
            document.getElementById('planetName').innerHTML = ` ${data.name} `;
            const element = document.getElementById("planetImage");
            const image = ` ${data.image} `;
            element.style.backgroundImage = "url(" + image + ")";
        });
}
