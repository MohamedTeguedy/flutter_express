const express = require("express");
const {
  getUserNotes,
  createNote,
  deleteNote,
  updateNote,
} = require("../controllers/notesControllers");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();
// // Récupérer toutes les notes
router.get("/notes", authMiddleware, getUserNotes);

// // ajouter une note
router.post("/notes", authMiddleware, createNote);

// // Mettre à jour une note
router.put("/notes/:noteId", authMiddleware, updateNote);

// // Supprimer une note
router.delete("/notes/:noteId", authMiddleware, deleteNote);
module.exports = router;

// router.post("/notes/:idNote/", authMiddleware, deleteNote);

// Ajouter une note

// router.post("/:userId/notes", post);

// // Récupérer toutes les notes d'un utilisateur
// router.get("/:userId/notes", get);
