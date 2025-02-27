// const express = require("express");
// const mongoose = require("mongoose");
// const bodyParser = require("body-parser");
// const dotenv = require("dotenv");
// const authRoutes = require("./routes/auth");
// const notesRoutes = require("./routes/notes");

// dotenv.config();

// const app = express();

// // Middleware
// app.use(bodyParser.json());

// // Routes
// app.use("/api/auth", authRoutes);
// app.use("/api", notesRoutes);

// const connectDB = async () => {
//   try {
//     await mongoose.connect(process.env.MONGO_URI, {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//     });
//     console.log("MongoDB connected");
//   } catch (err) {
//     console.error("MongoDB connection error:", err.message);
//     process.exit(1); // Exit the process if the connection fails
//   }
// };

// connectDB();

// module.exports = app;

const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const authRoutes = require("./routes/auth");
const notesRoutes = require("./routes/notes");

dotenv.config();

const app = express();

// Middleware
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api", notesRoutes);

// MongoDB connection
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("MongoDB connected");
  } catch (err) {
    console.error("MongoDB connection error:", err.message);
    process.exit(1); // Exit the process if the connection fails
  }
};

connectDB();

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack); // Log the error for debugging
  res
    .status(500)
    .json({ message: "Something went wrong!", error: err.message });
});

// Start the server

module.exports = app;
