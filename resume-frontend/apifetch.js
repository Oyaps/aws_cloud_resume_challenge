// const countEl = document.getElementById("visitors");

// updateVisitCount();

// function updateVisitCount() {
//   fetch("https://zl7hezvfy6.execute-api.us-east-1.amazonaws.com/Prod/visitors")
//     .then((response) => {
//       return response.json();
//     })
//     .then((data) => {
//       console.log(data);
//       document.getElementById("visitors").innerHTML = data["count"];
//     });
// }

const countEl = document.getElementById("visitors");

updateVisitCount();

function updateVisitCount() {
  fetch("https://y4qcesst5h.execute-api.us-east-1.amazonaws.com/Prod/visitors")
    .then((response) => {
      return response.json();
    })
    .then((data) => {
      console.log(data);
      document.getElementById("visitors").innerHTML = data["count"];
    });
}
