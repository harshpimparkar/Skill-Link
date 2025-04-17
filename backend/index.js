import express, { json } from "express";
import { connect } from "mongoose";
import cors from "cors";
import dotenv from "dotenv";
import authRoutes from "./routes/auth.js"; 
import courseRoutes from "./routes/courses.js"; 
import enrollmentRoutes from "./routes/enrollment.js";
dotenv.config();

const app = express();
const PORT = process.env.PORT || 7000;

// Middleware
// app.use(cors());
app.use(cors({ origin: "*" }));
app.use(json());

// MongoDB Connection
connect(process.env.MONGO_URL)
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("MongoDB connection error:", err));

// Routes
app.get("/", (req, res) => res.send("Skill Link Backend"));
app.use("/api/auth", authRoutes); 
app.use("/api/course", courseRoutes); 
app.use('/api/enrollments', enrollmentRoutes);
app.get("/api", (req, res) => {
  res.send("Skill Link API");
});

app.listen(PORT, () =>
  console.log(`Server running on port ${PORT}\n http://localhost:${PORT}`)
);
