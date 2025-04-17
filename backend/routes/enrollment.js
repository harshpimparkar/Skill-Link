import express from 'express';
import {
  enrollInCourse,
  getEnrolledCourses,
  getEnrollmentDetails,
  updateLectureProgress,
  updatePaymentStatus
} from '../controllers/enrollmentController.js';
import {authenticate} from '../middleware/authmid.js';

const router = express.Router();

// All routes are protected - require authentication
router.use(authenticate);

// Enrollment routes
router.post('/', enrollInCourse);
router.get('/', getEnrolledCourses);
router.get('/:courseId', getEnrollmentDetails);
router.put('/:courseId/lectures/:lectureId/progress', updateLectureProgress);
router.put('/:courseId/payment', updatePaymentStatus);

export default router;
