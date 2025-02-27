const express = require("express");
const { register, login } = require("../controllers/autheController");

const router = express.Router();

// Route d'inscription
router.post("/register", register);

// Route de connexion
router.post("/login", login);

module.exports = router;
