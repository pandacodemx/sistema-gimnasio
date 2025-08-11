export const formatearFechaHora = fechaString => {
  if (!fechaString) return "Sin fecha";

  const [fechaPart, horaPart] = fechaString.split(" ");
  const [year, month, day] = fechaPart.split("-");
  const [hours, minutes] = horaPart.split(":");
  const meses = [
    "Ene",
    "Feb",
    "Mar",
    "Abr",
    "May",
    "Jun",
    "Jul",
    "Ago",
    "Sep",
    "Oct",
    "Nov",
    "Dic"
  ];

  return `${day} ${meses[parseInt(month) - 1]} ${year} ${hours}:${minutes}`;
};
