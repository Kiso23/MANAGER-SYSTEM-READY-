export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validatePassword = (password: string): boolean => {
  return password.length >= 6;
};

export const validateTaskInput = (title: string, description?: string): boolean => {
  if (!title || title.trim().length === 0) return false;
  if (description && description.trim().length > 500) return false;
  return true;
};
