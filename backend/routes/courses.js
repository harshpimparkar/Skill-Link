// routes/courses.js (updated)
import express from "express";
import {getAllCourses,getCoursesByCategory,getCourseById,getLectureById,createCourse} from "../controllers/courseController.js";
import { authenticate } from "../middleware/authmid.js";

const router = express.Router();

// Public routes
router.get('/', getAllCourses);
router.get('/category/:category', getCoursesByCategory);
router.get('/:id', getCourseById);
router.get('/:courseId/lectures/:lectureId', getLectureById);

// Admin routes (protected)
router.post('/', authenticate, createCourse);



export default router;