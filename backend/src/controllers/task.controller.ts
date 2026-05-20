import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';
import { validateTaskInput } from '../utils/validators.js';

const prisma = new PrismaClient();

export const getTasks = async (req: Request, res: Response): Promise<void> => {
  try {
    if (!req.user) {
      res.status(401).json({ error: 'User not authenticated' });
      return;
    }

    let tasks;

    // Admin sees all tasks, users see only their own
    if (req.user.role === 'ADMIN') {
      tasks = await prisma.task.findMany({
        include: { user: { select: { id: true, name: true, email: true } } },
        orderBy: { createdAt: 'desc' },
      });
    } else {
      tasks = await prisma.task.findMany({
        where: { userId: req.user.id },
        include: { user: { select: { id: true, name: true, email: true } } },
        orderBy: { createdAt: 'desc' },
      });
    }

    res.status(200).json({ tasks });
  } catch (error) {
    console.error('Get tasks error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const createTask = async (req: Request, res: Response): Promise<void> => {
  try {
    if (!req.user) {
      res.status(401).json({ error: 'User not authenticated' });
      return;
    }

    const { title, description } = req.body;

    if (!validateTaskInput(title, description)) {
      res.status(400).json({ error: 'Invalid task input' });
      return;
    }

    const task = await prisma.task.create({
      data: {
        title,
        description: description || null,
        userId: req.user.id,
      },
      include: { user: { select: { id: true, name: true, email: true } } },
    });

    res.status(201).json({
      message: 'Task created successfully',
      task,
    });
  } catch (error) {
    console.error('Create task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateTask = async (req: Request, res: Response): Promise<void> => {
  try {
    if (!req.user) {
      res.status(401).json({ error: 'User not authenticated' });
      return;
    }

    const { id } = req.params as { id: string };
    const { title, description, completed } = req.body;

    // Find task
    const task = await prisma.task.findUnique({ where: { id } });
    if (!task) {
      res.status(404).json({ error: 'Task not found' });
      return;
    }

    // Check authorization
    if (req.user.role !== 'ADMIN' && task.userId !== req.user.id) {
      res.status(403).json({ error: 'Insufficient permissions' });
      return;
    }

    // Validate input
    if (title && !validateTaskInput(title, description)) {
      res.status(400).json({ error: 'Invalid task input' });
      return;
    }

    const updatedTask = await prisma.task.update({
      where: { id },
      data: {
        ...(title && { title }),
        ...(description !== undefined && { description }),
        ...(completed !== undefined && { completed }),
      },
      include: { user: { select: { id: true, name: true, email: true } } },
    });

    res.status(200).json({
      message: 'Task updated successfully',
      task: updatedTask,
    });
  } catch (error) {
    console.error('Update task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteTask = async (req: Request, res: Response): Promise<void> => {
  try {
    if (!req.user) {
      res.status(401).json({ error: 'User not authenticated' });
      return;
    }

    const { id } = req.params as { id: string };

    // Find task
    const task = await prisma.task.findUnique({ where: { id } });
    if (!task) {
      res.status(404).json({ error: 'Task not found' });
      return;
    }

    // Check authorization
    if (req.user.role !== 'ADMIN' && task.userId !== req.user.id) {
      res.status(403).json({ error: 'Insufficient permissions' });
      return;
    }

    await prisma.task.delete({ where: { id } });

    res.status(200).json({ message: 'Task deleted successfully' });
  } catch (error) {
    console.error('Delete task error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
