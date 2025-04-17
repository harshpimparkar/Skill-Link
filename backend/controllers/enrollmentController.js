import mongoose from 'mongoose';
import Enrollment from '../models/Enrollment.js';
import Course from '../models/Course.js';

// Enroll in a course
export const enrollInCourse = async (req, res) => {
  try {
    const { courseId } = req.body;
    const userId = req.user.id;

    if (!mongoose.Types.ObjectId.isValid(courseId)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid course ID'
      });
    }

    const course = await Course.findById(courseId);

    if (!course) {
      return res.status(404).json({
        success: false,
        message: 'Course not found'
      });
    }

    const existingEnrollment = await Enrollment.findOne({ user: userId, course: courseId });

    if (existingEnrollment) {
      return res.status(400).json({
        success: false,
        message: 'Already enrolled in this course'
      });
    }

    const lectureProgress = course.lectures.map(lecture => ({
      lectureId: lecture._id,
      completed: false,
      lastWatchedPosition: 0
    }));

    const enrollment = await Enrollment.create({
      user: userId,
      course: courseId,
      lectureProgress,
      isPaid: false
    });

    return res.status(201).json({
      success: true,
      data: enrollment
    });
  } catch (error) {
    console.error('Error enrolling in course:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Get all enrolled courses for current user
export const getEnrolledCourses = async (req, res) => {
  try {
    const userId = req.user.id;

    const enrollments = await Enrollment.find({ user: userId }).populate({
      path: 'course',
      select: 'title description image category'
    });

    const enrolledCourses = enrollments.map(enrollment => ({
      id: enrollment.course._id,
      title: enrollment.course.title,
      description: enrollment.course.description,
      image: enrollment.course.image,
      category: enrollment.course.category,
      enrollmentDate: enrollment.enrollmentDate,
      isPaid: enrollment.isPaid,
      progress: calculateProgress(enrollment.lectureProgress)
    }));

    return res.status(200).json({
      success: true,
      count: enrolledCourses.length,
      data: enrolledCourses
    });
  } catch (error) {
    console.error('Error getting enrolled courses:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Get specific course enrollment details with lecture progress
export const getEnrollmentDetails = async (req, res) => {
  try {
    const { courseId } = req.params;
    const userId = req.user.id;

    if (!mongoose.Types.ObjectId.isValid(courseId)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid course ID'
      });
    }

    const enrollment = await Enrollment.findOne({
      user: userId,
      course: courseId
    }).populate('course');

    if (!enrollment) {
      return res.status(404).json({
        success: false,
        message: 'Enrollment not found'
      });
    }

    const response = {
      courseId: enrollment.course._id,
      title: enrollment.course.title,
      description: enrollment.course.description,
      image: enrollment.course.image,
      category: enrollment.course.category,
      enrollmentDate: enrollment.enrollmentDate,
      isPaid: enrollment.isPaid,
      certificateIssued: enrollment.certificateIssued,
      lectures: enrollment.course.lectures.map(lecture => {
        const progress = enrollment.lectureProgress.find(
          p => p.lectureId.toString() === lecture._id.toString()
        );

        return {
          id: lecture._id,
          title: lecture.title,
          description: lecture.description,
          videoUrl: lecture.videoUrl,
          duration: lecture.duration,
          order: lecture.order,
          completed: progress ? progress.completed : false,
          lastWatchedPosition: progress ? progress.lastWatchedPosition : 0,
          lastWatched: progress ? progress.lastWatched : null
        };
      })
    };

    return res.status(200).json({
      success: true,
      data: response
    });
  } catch (error) {
    console.error('Error getting enrollment details:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Update lecture progress
export const updateLectureProgress = async (req, res) => {
  try {
    const { courseId, lectureId } = req.params;
    const { position, completed } = req.body;
    const userId = req.user.id;

    if (!mongoose.Types.ObjectId.isValid(courseId) || !mongoose.Types.ObjectId.isValid(lectureId)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid course or lecture ID'
      });
    }

    const enrollment = await Enrollment.findOne({
      user: userId,
      course: courseId
    });

    if (!enrollment) {
      return res.status(404).json({
        success: false,
        message: 'Enrollment not found'
      });
    }

    const lectureProgressIndex = enrollment.lectureProgress.findIndex(
      p => p.lectureId.toString() === lectureId
    );

    if (lectureProgressIndex === -1) {
      return res.status(404).json({
        success: false,
        message: 'Lecture progress not found'
      });
    }

    enrollment.lectureProgress[lectureProgressIndex].lastWatchedPosition =
      position ?? enrollment.lectureProgress[lectureProgressIndex].lastWatchedPosition;

    if (completed !== undefined) {
      enrollment.lectureProgress[lectureProgressIndex].completed = completed;
    }

    enrollment.lectureProgress[lectureProgressIndex].lastWatched = Date.now();

    await enrollment.save();

    return res.status(200).json({
      success: true,
      data: enrollment.lectureProgress[lectureProgressIndex]
    });
  } catch (error) {
    console.error('Error updating lecture progress:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Update payment status after successful payment
export const updatePaymentStatus = async (req, res) => {
  try {
    const { courseId } = req.params;
    const userId = req.user.id;

    if (!mongoose.Types.ObjectId.isValid(courseId)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid course ID'
      });
    }

    const enrollment = await Enrollment.findOne({
      user: userId,
      course: courseId
    });

    if (!enrollment) {
      return res.status(404).json({
        success: false,
        message: 'Enrollment not found'
      });
    }

    enrollment.isPaid = true;
    enrollment.paymentDate = Date.now();

    await enrollment.save();

    return res.status(200).json({
      success: true,
      data: {
        isPaid: enrollment.isPaid,
        paymentDate: enrollment.paymentDate
      }
    });
  } catch (error) {
    console.error('Error updating payment status:', error);
    return res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Helper function to calculate progress
function calculateProgress(lectureProgress) {
  if (!lectureProgress || lectureProgress.length === 0) return 0;
  const completedLectures = lectureProgress.filter(lecture => lecture.completed).length;
  return Math.round((completedLectures / lectureProgress.length) * 100);
}
