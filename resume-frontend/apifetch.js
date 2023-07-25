const countEl = document.getElementById("visitors");

updateVisitCount();

function updateVisitCount() {
    fetch('https://v67hzqulo4.execute-api.us-east-1.amazonaws.com/Prod/visitors')
        .then(response => {
        return response.json()
      })
        .then(data => {
            console.log(data);
            document.getElementById("visitors").innerHTML = data['count'];
        })
    }
