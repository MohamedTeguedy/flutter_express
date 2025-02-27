// const jwt = require("jsonwebtoken");

// const authMiddleware = (req, res, next) => {
//   const token = req.header("Authorization")?.replace("Bearer ", "");

//   if (!token) {
//     return res.status(401).json({ message: "No token, authorization denied" });
//   }

//   try {
//     const decoded = jwt.verify(token, process.env.JWT_SECRET);
//     req.userId = decoded.userId;
//     next();
//   } catch (err) {
//     res.status(401).json({ message: "Token is not valid" });
//   }
// };

// module.exports = authMiddleware;

const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
  const token = req.header("Authorization");

  if (!token) {
    return res
      .status(401)
      .json({ message: "Aucun token, autorisation refusée" });
  }

  try {
    // Vérifier et extraire le token après "Bearer "
    const decoded = jwt.verify(token.split(" ")[1], process.env.JWT_SECRET);
    req.user = decoded; // Stocker les infos de l'utilisateur dans req.user
    next();
  } catch (err) {
    res.status(400).json({ message: "Token invalide" });
  }
};

module.exports = authMiddleware;
