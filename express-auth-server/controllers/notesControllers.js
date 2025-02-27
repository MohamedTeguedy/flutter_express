const express = require("express");

const User = require("../models/User"); // Importez votre modèle utilisateur
const Note = require("../models/Note");

// Ajouter une note
// const post = async (req, res) => {
//   try {
//     const { title, description } = req.body;
//     const user = await User.findById(req.params.userId);

//     if (!user) {
//       return res.status(404).json({ message: "Utilisateur non trouvé" });
//     }

//     user.notes.push({ title, description });
//     await user.save();

//     res.status(201).json(user.notes);
//   } catch (error) {
//     res
//       .status(500)
//       .json({ message: "Erreur lors de l'ajout de la note", error });
//   }
// };

const createNote = async (req, res) => {
  try {
    const { title, description } = req.body;

    // Vérifier si l'utilisateur est authentifié
    if (!req.user || !req.user.userId) {
      return res.status(401).json({ message: "Utilisateur non authentifié" });
    }

    // Créer une nouvelle note
    const newNote = new Note({
      userId: req.user.userId,
      title,
      description,
    });
    await newNote.save();

    // Ajouter la note à la liste de l'utilisateur
    await User.findByIdAndUpdate(req.user.userId, {
      $push: { notes: newNote._id },
    });

    res.status(201).json(newNote);
  } catch (error) {
    res.status(500).json({ message: "Erreur serveur" });
  }
};

// Récupérer toutes les notes d'un utilisateur
// const get = async (req, res) => {
//   try {
//     const user = await User.findById(req.params.userId);

//     if (!user) {
//       return res.status(404).json({ message: "Utilisateur non trouvé" });
//     }

//     res.status(200).json(user.notes);
//   } catch (error) {
//     res
//       .status(500)
//       .json({ message: "Erreur lors de la récupération des notes", error });
//   }
// };

// const getUserNotes = async (req, res) => {
//   try {
//     const notes = await Note.find({ userId: req.user.id }); // Récupérer uniquement les notes de l'utilisateur connecté
//     res.json(notes);
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: "Erreur serveur" });
//   }
// };

const getUserNotes = async (req, res) => {
  try {
    if (!req.user || !req.user.userId) {
      return res.status(401).json({ message: "Utilisateur non authentifié" });
    }

    const notes = await Note.find({ userId: req.user.userId });

    if (!notes.length) {
      return res.status(404).json({ message: "Aucune note trouvée" });
    }

    res.json(notes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

// Mettre à jour une note
const updateNote = async (req, res) => {
  try {
    const { title, description } = req.body;
    const { noteId } = req.params;

    // Vérifier si la note existe
    const note = await Note.findById(noteId);
    if (!note) {
      return res.status(404).json({ message: "Note non trouvée" });
    }

    // Mettre à jour la note
    const updatedNote = await Note.findByIdAndUpdate(
      noteId,
      { title, description },
      { new: true } // Retourne la note mise à jour
    );

    // Retourner la note mise à jour
    res.status(200).json(updatedNote);
  } catch (error) {
    res
      .status(500)
      .json({ message: "Erreur lors de la mise à jour de la note", error });
  }
};

// Supprimer une note
const deleteNote = async (req, res) => {
  try {
    const { noteId } = req.params;

    // Vérifier si la note existe
    const note = await Note.findById(noteId);
    if (!note) {
      return res.status(404).json({ message: "Note non trouvée" });
    }

    // Supprimer la note de la collection `Note`
    await Note.findByIdAndDelete(noteId);

    // Supprimer la note de la liste des notes de l'utilisateur
    const user = await User.findById(note.userId);
    if (user) {
      user.notes.pull(noteId); // Retirer la note de la liste des notes de l'utilisateur
      await user.save(); // Sauvegarder les modifications
    }

    // Renvoyer une réponse de succès
    res.status(200).json({ message: "Note supprimée avec succès" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Erreur lors de la suppression de la note", error });
  }
};

module.exports = { createNote, getUserNotes, deleteNote, updateNote };
