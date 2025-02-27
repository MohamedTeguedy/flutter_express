const app = require("./app");

// app.listen(PORT, () => {
//   console.log(`Server running on port ${PORT}`);
// });
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
