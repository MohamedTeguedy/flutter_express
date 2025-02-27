const User = require("../models/User");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

// Inscription
const register = async (req, res) => {
  const { username, password } = req.body;

  try {
    // Vérifier si l'utilisateur existe déjà
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: "Username already exists" });
    }

    // Créer un nouvel utilisateur
    const user = new User({ username, password });
    await user.save();

    // Générer un token JWT
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    res.status(201).json({ token });
  } catch (err) {
    res.status(500).json({ message: "Server error" });
    console.error("Erreur serveur :", err);
  }
};

// Connexion
// const login = async (req, res) => {
//   const { username, password } = req.body;

//   try {
//     // Vérifier si l'utilisateur existe
//     const user = await User.findOne({ username });
//     if (!user) {
//       return res.status(400).json({ message: "Invalid credentials" });
//     }

//     // Vérifier le mot de passe
//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) {
//       return res.status(400).json({ message: "Invalid credentials" });
//     }

//     // Générer un token JWT
//     const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
//       expiresIn: "1h",
//     });

//     res.json({ token });
//   } catch (err) {
//     res.status(500).json({ message: "Server error" });
//   }
// };
const login = async (req, res) => {
  const { username, password } = req.body;

  try {
    // Vérifier si l'utilisateur existe
    const user = await User.findOne({ username }).populate("notes"); // Charger les notes associées
    if (!user) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    // Vérifier le mot de passe
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    // Générer un token JWT
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });

    // Retourner le token et les notes de l'utilisateur
    res.json({
      token,
      notes: user.notes,
    });
  } catch (err) {
    res.status(500).json({ message: "Server error", error: err.message });
    console.error("Erreur serveur :", err);
  }
};

module.exports = { register, login };
