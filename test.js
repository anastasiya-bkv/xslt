const modal = document.getElementById("modalBlock");

function clickHandler() {
  modal.classList.add("show");
}
const btns = document.querySelectorAll(".table__btn-pay");
btns.forEach((btn) => btn.addEventListener("click", clickHandler));

$("#card input[name='card']").mask("9999 9999 9999 9999");
$("#card input[name='term']").mask("99 / 99");
$("#card input[name='cvv']").mask("999");

$("#card").submit((e) => {
  e.preventDefault();
  modal.classList.remove("show");
});

document.addEventListener("click", function (event) {
  if (
    event.target.closest("#modalBlock") &&
    !event.target.closest(".modal-content")
  ) {
    modal.classList.remove("show");
  }
});
