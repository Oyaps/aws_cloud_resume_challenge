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
<<<<<<< HEAD
  fetch("https://y4qcesst5h.execute-api.us-east-1.amazonaws.com/Prod/visitors")
=======
  fetch('https://zl7hezvfy6.execute-api.us-east-1.amazonaws.com/Prod/visitors')
>>>>>>> 8e4156d8cc4d02416bd58e6fc40fe628e34a6604
    .then((response) => {
      return response.json();
    })
    .then((data) => {
      console.log(data);
<<<<<<< HEAD
      document.getElementById("visitors").innerHTML = data["count"];
=======
      document.getElementById("visitors").innerHTML = data['count'];
>>>>>>> 8e4156d8cc4d02416bd58e6fc40fe628e34a6604
    });
}
