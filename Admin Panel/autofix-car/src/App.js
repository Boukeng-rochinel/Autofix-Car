import React, { useState, useEffect, useCallback } from 'react';
import {
    AppBar, Toolbar, Typography, Button, Box, Container,
    Drawer, List, ListItem, ListItemButton, ListItemIcon, ListItemText,
    Card, CardContent, Grid, TextField, Dialog, DialogTitle,
    DialogContent, DialogActions, TableContainer, Table, TableHead,
    TableRow, TableCell, TableBody, Paper, Chip, IconButton
} from '@mui/material';
import {
    Home as HomeIcon, PeopleAlt as UsersIcon, History as ActivityIcon,
    Settings as SettingsIcon, Notifications as BellIcon, Message as MessageSquareIcon,
    Lightbulb as LightbulbIcon, HelpOutline as HelpCircleIcon, Add as PlusIcon,
    Edit as EditIcon, Delete as Trash2Icon, Close as CloseIcon, Check as CheckIcon
} from '@mui/icons-material';
import { createTheme, ThemeProvider } from '@mui/material/styles';

// --- Custom Theme ---
const theme = createTheme({
    typography: {
        fontFamily: 'Inter, sans-serif', // Assuming Inter font is available
    },
    palette: {
        primary: {
            main: '#4f46e5', // Indigo 600
        },
        secondary: {
            main: '#10b981', // Green 500
        },
        error: {
            main: '#ef4444', // Red 500
        },
        warning: {
            main: '#f97316', // Orange 500
        },
        info: {
            main: '#3b82f6', // Blue 500
        }
    },
    components: {
        MuiButton: {
            styleOverrides: {
                root: {
                    borderRadius: 8,
                    textTransform: 'none',
                    fontWeight: 600,
                    boxShadow: '0px 4px 6px rgba(0, 0, 0, 0.1)',
                    transition: 'all 0.2s ease-in-out',
                    '&:hover': {
                        boxShadow: '0px 6px 10px rgba(0, 0, 0, 0.15)',
                    },
                },
            },
        },
        MuiCard: {
            styleOverrides: {
                root: {
                    borderRadius: 12,
                    boxShadow: '0px 4px 8px rgba(0, 0, 0, 0.08)',
                },
            },
        },
        MuiTextField: {
            styleOverrides: {
                root: {
                    '& .MuiOutlinedInput-root': {
                        borderRadius: 8,
                        backgroundColor: '#f3f4f6', // Gray 100
                        '& fieldset': {
                            borderColor: 'transparent',
                        },
                        '&:hover fieldset': {
                            borderColor: 'transparent',
                        },
                        '&.Mui-focused fieldset': {
                            borderColor: '#4f46e5', // Indigo 600
                            borderWidth: 2,
                        },
                    },
                },
            },
        },
        MuiDialog: {
            styleOverrides: {
                paper: {
                    borderRadius: 12,
                },
            },
        },
        MuiTableCell: {
            styleOverrides: {
                head: {
                    fontWeight: 'bold',
                    backgroundColor: '#f9fafb', // Gray 50
                    color: '#6b7280', // Gray 500
                    textTransform: 'uppercase',
                    fontSize: 12,
                },
            },
        },
    },
});

// --- apiService.js content moved here ---
// This file simulates communication with an external backend.
// In a real application, these would be actual fetch calls to your API endpoints.

// A mock database to simulate backend data storage
let mockDb = {
    users: [
        { id: 'user_12345', email: 'john.doe@example.com', createdAt: new Date('2024-01-15T10:00:00Z'), lastActivity: new Date('2025-07-15T10:30:00Z') },
        { id: 'user_67890', email: 'jane.smith@example.com', createdAt: new Date('2024-02-20T11:00:00Z'), lastActivity: new Date('2025-07-14T15:00:00Z') },
        { id: 'user_abcde', email: 'admin@example.com', createdAt: new Date('2023-11-01T09:00:00Z'), lastActivity: new Date('2025-07-16T09:00:00Z') },
    ],
    activityLogs: [
        { id: 'log_001', userId: 'user_12345', type: 'Login', details: 'User logged in', timestamp: new Date('2025-07-15T10:30:00Z') },
        { id: 'log_002', userId: 'user_67890', type: 'App Usage', details: 'Completed a task', timestamp: new Date('2025-07-14T15:00:00Z') },
        { id: 'log_003', userId: 'user_abcde', type: 'Admin Action', details: 'Updated a mechanic', timestamp: new Date('2025-07-16T09:00:00Z') },
    ],
    mechanics: [
        { id: 'mech_001', title: 'Daily Login Bonus', description: 'Users receive a bonus for logging in daily.', createdAt: new Date('2024-03-01T08:00:00Z') },
        { id: 'mech_002', title: 'Weekly Challenge', description: 'New challenge every week with special rewards.', createdAt: new Date('2024-04-10T09:00:00Z') },
    ],
    notifications: [
        { id: 'notif_001', title: 'Welcome!', message: 'Thanks for joining our app!', sentAt: new Date('2024-01-15T10:05:00Z'), sentBy: 'admin_mock' },
        { id: 'notif_002', title: 'New Feature Live!', message: 'Check out our new feature in the latest update.', sentAt: new Date('2025-06-20T14:00:00Z'), sentBy: 'admin_mock' },
    ],
    faqs: [
        { id: 'faq_001', question: 'How do I reset my password?', answer: 'You can reset your password from the login screen by clicking "Forgot Password".', createdAt: new Date('2024-01-01T10:00:00Z') },
        { id: 'faq_002', question: 'Where can I find my profile?', answer: 'Your profile can be accessed from the main menu under "Settings".', createdAt: new Date('2024-01-05T11:00:00Z') },
    ],
    tips: [
        { id: 'tip_001', title: 'Pro Tip: Save Battery', content: 'Turn off background app refresh for unused apps.', createdAt: new Date('2024-02-10T12:00:00Z') },
        { id: 'tip_002', title: 'Improve Performance', content: 'Clear app cache regularly for smoother experience.', createdAt: new Date('2024-03-20T13:00:00Z') },
    ],
    userMessages: [
        { id: 'msg_001', senderId: 'user_12345', content: 'My app is crashing frequently.', timestamp: new Date('2025-07-10T09:00:00Z'), status: 'new' },
        { id: 'msg_002', senderId: 'user_67890', content: 'I love the new update!', timestamp: new Date('2025-07-12T11:00:00Z'), reply: 'Thank you for your feedback!', repliedAt: new Date('2025-07-12T11:30:00Z'), repliedBy: 'admin_mock', status: 'replied' },
    ],
};

// Helper to simulate API delay
const simulateDelay = (ms = 500) => new Promise(resolve => setTimeout(resolve, ms));

const generateUniqueId = () => Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);

const apiService = {
    // --- Dashboard Stats ---
    getDashboardStats: async (appId) => {
        await simulateDelay();
        // In a real scenario, this would be a dedicated backend endpoint
        // Example: const response = await fetch(`/api/${appId}/dashboard-stats`);
        // Example: return response.json();
        return {
            users: mockDb.users.length,
            messages: mockDb.userMessages.length,
            activities: mockDb.activityLogs.length,
        };
    },

    // --- User Management ---
    getUsers: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/users`);
        // Example: return response.json();
        const sortedUsers = [...mockDb.users].sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
        return sortedUsers;
    },

    // --- Activity Logs ---
    getActivityLogs: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/activity-logs?limit=50&orderBy=timestamp:desc`);
        // Example: return response.json();
        const sortedLogs = [...mockDb.activityLogs].sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());
        return sortedLogs.slice(0, 50);
    },

    // --- Mechanics Management ---
    getMechanics: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/mechanics`);
        // Example: return response.json();
        return mockDb.mechanics;
    },
    addMechanic: async (appId, mechanicData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/mechanics`, { method: 'POST', body: JSON.stringify(mechanicData) });
        // Example: return response.json();
        const newMechanic = { ...mechanicData, id: generateUniqueId(), createdAt: new Date() };
        mockDb.mechanics.push(newMechanic);
        return newMechanic;
    },
    updateMechanic: async (appId, id, mechanicData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/mechanics/${id}`, { method: 'PUT', body: JSON.stringify(mechanicData) });
        // Example: return response.json();
        const index = mockDb.mechanics.findIndex(m => m.id === id);
        if (index !== -1) {
            mockDb.mechanics[index] = { ...mockDb.mechanics[index], ...mechanicData, updatedAt: new Date() };
            return mockDb.mechanics[index];
        }
        throw new Error('Mechanic not found');
    },
    deleteMechanic: async (appId, id) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/mechanics/${id}`, { method: 'DELETE' });
        // Example: return response.json();
        mockDb.mechanics = mockDb.mechanics.filter(m => m.id !== id);
        return { success: true };
    },

    // --- Notifications ---
    getNotifications: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/notifications?limit=20&orderBy=sentAt:desc`);
        // Example: return response.json();
        const sortedNotifications = [...mockDb.notifications].sort((a, b) => b.sentAt.getTime() - a.sentAt.getTime());
        return sortedNotifications.slice(0, 20);
    },
    sendNotification: async (appId, notificationData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/notifications`, { method: 'POST', body: JSON.stringify(notificationData) });
        // Example: return response.json();
        const newNotification = { ...notificationData, id: generateUniqueId(), sentAt: new Date() };
        mockDb.notifications.push(newNotification);
        return newNotification;
    },

    // --- FAQs Management ---
    getFaqs: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/faqs`);
        // Example: return response.json();
        return mockDb.faqs;
    },
    addFaq: async (appId, faqData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/faqs`, { method: 'POST', body: JSON.stringify(faqData) });
        // Example: return response.json();
        const newFaq = { ...faqData, id: generateUniqueId(), createdAt: new Date() };
        mockDb.faqs.push(newFaq);
        return newFaq;
    },
    updateFaq: async (appId, id, faqData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/faqs/${id}`, { method: 'PUT', body: JSON.stringify(faqData) });
        // Example: return response.json();
        const index = mockDb.faqs.findIndex(f => f.id === id);
        if (index !== -1) {
            mockDb.faqs[index] = { ...mockDb.faqs[index], ...faqData, updatedAt: new Date() };
            return mockDb.faqs[index];
        }
        throw new Error('FAQ not found');
    },
    deleteFaq: async (appId, id) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/faqs/${id}`, { method: 'DELETE' });
        // Example: return response.json();
        mockDb.faqs = mockDb.faqs.filter(f => f.id !== id);
        return { success: true };
    },

    // --- Tips Management ---
    getTips: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/tips`);
        // Example: return response.json();
        return mockDb.tips;
    },
    addTip: async (appId, tipData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/tips`, { method: 'POST', body: JSON.stringify(tipData) });
        // Example: return response.json();
        const newTip = { ...tipData, id: generateUniqueId(), createdAt: new Date() };
        mockDb.tips.push(newTip);
        return newTip;
    },
    updateTip: async (appId, id, tipData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/tips/${id}`, { method: 'PUT', body: JSON.stringify(tipData) });
        // Example: return response.json();
        const index = mockDb.tips.findIndex(t => t.id === id);
        if (index !== -1) {
            mockDb.tips[index] = { ...mockDb.tips[index], ...tipData, updatedAt: new Date() };
            return mockDb.tips[index];
        }
        throw new Error('Tip not found');
    },
    deleteTip: async (appId, id) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/tips/${id}`, { method: 'DELETE' });
        // Example: return response.json();
        mockDb.tips = mockDb.tips.filter(t => t.id !== id);
        return { success: true };
    },

    // --- User Messages ---
    getUserMessages: async (appId) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/user-messages?orderBy=timestamp:desc`);
        // Example: return response.json();
        const sortedMessages = [...mockDb.userMessages].sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());
        return sortedMessages;
    },
    replyToMessage: async (appId, id, replyData) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/user-messages/${id}/reply`, { method: 'POST', body: JSON.stringify(replyData) });
        // Example: return response.json();
        const index = mockDb.userMessages.findIndex(m => m.id === id);
        if (index !== -1) {
            mockDb.userMessages[index] = { ...mockDb.userMessages[index], ...replyData, repliedAt: new Date(), status: 'replied' };
            return mockDb.userMessages[index];
        }
        throw new Error('Message not found');
    },
    deleteMessage: async (appId, id) => {
        await simulateDelay();
        // Example: const response = await fetch(`/api/${appId}/user-messages/${id}`, { method: 'DELETE' });
        // Example: return response.json();
        mockDb.userMessages = mockDb.userMessages.filter(m => m.id !== id);
        return { success: true };
    },
};


// --- Custom Dialogs (replacing alert/confirm) ---

const AlertDialog = ({ open, title, message, onClose }) => (
    <Dialog open={open} onClose={onClose}>
        <DialogTitle>{title}</DialogTitle>
        <DialogContent>
            <Typography>{message}</Typography>
        </DialogContent>
        <DialogActions>
            <Button onClick={onClose} color="primary">OK</Button>
        </DialogActions>
    </Dialog>
);

const ConfirmationDialog = ({ open, title, message, onConfirm, onCancel }) => (
    <Dialog open={open} onClose={onCancel}>
        <DialogTitle>{title}</DialogTitle>
        <DialogContent>
            <Typography>{message}</Typography>
        </DialogContent>
        <DialogActions>
            <Button onClick={onCancel} color="inherit">Cancel</Button>
            <Button onClick={onConfirm} color="error" variant="contained">Confirm</Button>
        </DialogActions>
    </Dialog>
);

// --- Page Components ---

const Dashboard = ({ appId }) => {
    const [stats, setStats] = useState({ users: 0, messages: 0, activities: 0 });
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchStats = async () => {
            setLoading(true);
            setError(null);
            try {
                // Placeholder API call
                // In a real app, replace apiService.getDashboardStats with a direct fetch call:
                // const response = await fetch(`/api/${appId}/dashboard-stats`);
                // if (!response.ok) throw new Error('Failed to fetch dashboard stats');
                // const data = await response.json();
                const data = await apiService.getDashboardStats(appId); // Using mock apiService for demonstration
                setStats(data);
            } catch (err) {
                console.error("Error fetching dashboard stats:", err);
                setError("Failed to load dashboard stats.");
                // Fallback to mock data if API fails for demonstration
                setStats({ users: 150, messages: 25, activities: 500 });
            } finally {
                setLoading(false);
            }
        };

        fetchStats();
    }, [appId]);

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading dashboard...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Box sx={{ p: 3 }}>
            <Typography variant="h4" component="h1" gutterBottom sx={{ fontWeight: 'bold', color: 'text.primary' }}>
                Admin Dashboard
            </Typography>
            <Grid container spacing={3} sx={{ mb: 4 }}>
                <Grid item xs={12} md={4}>
                    <Card sx={{ background: 'linear-gradient(to right, #4f46e5, #8b5cf6)', color: 'white' }}>
                        <CardContent>
                            <Typography variant="h6" sx={{ opacity: 0.8 }}>Total Users</Typography>
                            <Typography variant="h2" sx={{ fontWeight: 'bold' }}>{stats.users}</Typography>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} md={4}>
                    <Card sx={{ background: 'linear-gradient(to right, #10b981, #14b8a6)', color: 'white' }}>
                        <CardContent>
                            <Typography variant="h6" sx={{ opacity: 0.8 }}>New Messages</Typography>
                            <Typography variant="h2" sx={{ fontWeight: 'bold' }}>{stats.messages}</Typography>
                        </CardContent>
                    </Card>
                </Grid>
                <Grid item xs={12} md={4}>
                    <Card sx={{ background: 'linear-gradient(to right, #f97316, #ef4444)', color: 'white' }}>
                        <CardContent>
                            <Typography variant="h6" sx={{ opacity: 0.8 }}>Recent Activities</Typography>
                            <Typography variant="h2" sx={{ fontWeight: 'bold' }}>{stats.activities}</Typography>
                        </CardContent>
                    </Card>
                </Grid>
            </Grid>
            <Card>
                <CardContent>
                    <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                        Quick Actions
                    </Typography>
                    <Grid container spacing={2}>
                        <Grid item>
                            <Button variant="contained" startIcon={<BellIcon />}>Send Notification</Button>
                        </Grid>
                        <Grid item>
                            <Button variant="contained" startIcon={<PlusIcon />} color="secondary">Add New FAQ</Button>
                        </Grid>
                        <Grid item>
                            <Button variant="contained" startIcon={<UsersIcon />} sx={{ backgroundColor: '#64748b', '&:hover': { backgroundColor: '#475569' } }}>Manage Users</Button>
                        </Grid>
                    </Grid>
                </CardContent>
            </Card>
        </Box>
    );
};

const UserManagement = ({ appId }) => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchUsers = async () => {
            setLoading(true);
            setError(null);
            try {
                // Placeholder API call
                // const response = await fetch(`/api/${appId}/users`);
                // if (!response.ok) throw new Error('Failed to fetch users');
                // const data = await response.json();
                const data = await apiService.getUsers(appId); // Using mock apiService for demonstration
                setUsers(data);
            } catch (err) {
                console.error("Error fetching users:", err);
                setError("Failed to load users. Please try again.");
                // Fallback to empty array for demonstration
                setUsers([]);
            } finally {
                setLoading(false);
            }
        };

        fetchUsers();
    }, [appId]);

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading users...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                User Management (Total: {users.length})
            </Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                Note: For multi-user apps, it is MANDATORY to show the complete `userId` string on the main UI. This is important for other users to find each other.
            </Typography>
            {users.length === 0 ? (
                <Typography color="text.secondary">No users found.</Typography>
            ) : (
                <TableContainer component={Paper} sx={{ borderRadius: 2, boxShadow: 1 }}>
                    <Table sx={{ minWidth: 650 }} aria-label="user management table">
                        <TableHead>
                            <TableRow>
                                <TableCell>User ID</TableCell>
                                <TableCell>Email (example)</TableCell>
                                <TableCell>Last Activity (example)</TableCell>
                                <TableCell>Actions</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {users.map((user) => (
                                <TableRow key={user.id} sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                                    <TableCell component="th" scope="row" sx={{ fontWeight: 'medium' }}>{user.id}</TableCell>
                                    <TableCell>{user.email || 'N/A'}</TableCell>
                                    <TableCell>{user.lastActivity ? new Date(user.lastActivity).toLocaleString() : 'N/A'}</TableCell>
                                    <TableCell>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<EditIcon />}
                                            sx={{ mr: 1, borderColor: 'primary.main', color: 'primary.main' }}
                                            onClick={() => alert('Edit User functionality not yet implemented.')} // Placeholder
                                        >
                                            Edit
                                        </Button>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<Trash2Icon />}
                                            color="error"
                                            onClick={() => alert('Delete User functionality not yet implemented.')} // Placeholder
                                        >
                                            Delete
                                        </Button>
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TableContainer>
            )}
        </Card>
    );
};

const ActivityLogs = ({ appId }) => {
    const [logs, setLogs] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchLogs = async () => {
            setLoading(true);
            setError(null);
            try {
                // Placeholder API call
                // const response = await fetch(`/api/${appId}/activity-logs`);
                // if (!response.ok) throw new Error('Failed to fetch activity logs');
                // const data = await response.json();
                const data = await apiService.getActivityLogs(appId); // Using mock apiService for demonstration
                setLogs(data);
            } catch (err) {
                console.error("Error fetching activity logs:", err);
                setError("Failed to load activity logs. Please try again.");
                setLogs([]);
            } finally {
                setLoading(false);
            }
        };

        fetchLogs();
    }, [appId]);

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading activity logs...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                User Activity Logs
            </Typography>
            {logs.length === 0 ? (
                <Typography color="text.secondary">No activity logs found.</Typography>
            ) : (
                <TableContainer component={Paper} sx={{ borderRadius: 2, boxShadow: 1 }}>
                    <Table sx={{ minWidth: 650 }} aria-label="activity logs table">
                        <TableHead>
                            <TableRow>
                                <TableCell>Timestamp</TableCell>
                                <TableCell>User ID</TableCell>
                                <TableCell>Activity Type</TableCell>
                                <TableCell>Details</TableCell>
                            </TableRow>
                        </TableHead>
                        <TableBody>
                            {logs.map((log) => (
                                <TableRow key={log.id} sx={{ '&:last-child td, &:last-child th': { border: 0 } }}>
                                    <TableCell component="th" scope="row" sx={{ fontWeight: 'medium' }}>
                                        {log.timestamp ? new Date(log.timestamp).toLocaleString() : 'N/A'}
                                    </TableCell>
                                    <TableCell>{log.userId || 'N/A'}</TableCell>
                                    <TableCell>{log.type || 'N/A'}</TableCell>
                                    <TableCell>{log.details || 'N/A'}</TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                </TableContainer>
            )}
        </Card>
    );
};

const MechanicsManagement = ({ appId }) => {
    const [mechanics, setMechanics] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [currentMechanic, setCurrentMechanic] = useState(null);
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const [alertOpen, setAlertOpen] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');
    const [confirmOpen, setConfirmOpen] = useState(false);
    const [confirmId, setConfirmId] = useState(null);

    const fetchMechanics = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/mechanics`);
            // if (!response.ok) throw new Error('Failed to fetch mechanics');
            // const data = await response.json();
            const data = await apiService.getMechanics(appId); // Using mock apiService for demonstration
            setMechanics(data);
        } catch (err) {
            console.error("Error fetching mechanics:", err);
            setError("Failed to load mechanics. Please try again.");
            setMechanics([]);
        } finally {
            setLoading(false);
        }
    }, [appId]);

    useEffect(() => {
        fetchMechanics();
    }, [fetchMechanics]);

    const openAddModal = () => {
        setCurrentMechanic(null);
        setTitle('');
        setDescription('');
        setIsModalOpen(true);
    };

    const openEditModal = (mechanic) => {
        setCurrentMechanic(mechanic);
        setTitle(mechanic.title);
        setDescription(mechanic.description);
        setIsModalOpen(true);
    };

    const handleSaveMechanic = async () => {
        if (!title || !description) {
            setAlertMessage("Title and Description are required.");
            setAlertOpen(true);
            return;
        }

        try {
            if (currentMechanic) {
                // Placeholder API call for update
                // const response = await fetch(`/api/${appId}/mechanics/${currentMechanic.id}`, {
                //     method: 'PUT',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ title, description }),
                // });
                // if (!response.ok) throw new Error('Failed to update mechanic');
                await apiService.updateMechanic(appId, currentMechanic.id, { title, description }); // Using mock apiService
            } else {
                // Placeholder API call for add
                // const response = await fetch(`/api/${appId}/mechanics`, {
                //     method: 'POST',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ title, description }),
                // });
                // if (!response.ok) throw new Error('Failed to add mechanic');
                await apiService.addMechanic(appId, { title, description }); // Using mock apiService
            }
            setIsModalOpen(false);
            setAlertMessage("Mechanic saved successfully!");
            setAlertOpen(true);
            fetchMechanics(); // Re-fetch data
        } catch (e) {
            console.error("Error saving mechanic:", e);
            setAlertMessage("Error saving mechanic. Please try again.");
            setAlertOpen(true);
        }
    };

    const handleDeleteClick = (id) => {
        setConfirmId(id);
        setConfirmOpen(true);
    };

    const handleConfirmDelete = async () => {
        setConfirmOpen(false);
        try {
            // Placeholder API call for delete
            // const response = await fetch(`/api/${appId}/mechanics/${confirmId}`, {
            //     method: 'DELETE',
            // });
            // if (!response.ok) throw new Error('Failed to delete mechanic');
            await apiService.deleteMechanic(appId, confirmId); // Using mock apiService
            setAlertMessage("Mechanic deleted successfully!");
            setAlertOpen(true);
            fetchMechanics(); // Re-fetch data
        } catch (e) {
            console.error("Error deleting mechanic:", e);
            setAlertMessage("Error deleting mechanic. Please try again.");
            setAlertOpen(true);
        } finally {
            setConfirmId(null);
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading mechanics...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                Mechanics Management
            </Typography>
            <Button variant="contained" startIcon={<PlusIcon />} onClick={openAddModal} sx={{ mb: 3, backgroundColor: 'secondary.main' }}>
                Add New Mechanic
            </Button>

            {mechanics.length === 0 ? (
                <Typography color="text.secondary">No mechanics defined yet.</Typography>
            ) : (
                <Grid container spacing={3}>
                    {mechanics.map(mechanic => (
                        <Grid item xs={12} md={6} lg={4} key={mechanic.id}>
                            <Card variant="outlined" sx={{ p: 2, display: 'flex', flexDirection: 'column', height: '100%' }}>
                                <CardContent sx={{ flexGrow: 1 }}>
                                    <Typography variant="h6" component="h3" sx={{ fontWeight: 'bold', mb: 1 }}>{mechanic.title}</Typography>
                                    <Typography variant="body2" color="text.secondary">{mechanic.description}</Typography>
                                </CardContent>
                                <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 2 }}>
                                    <Button
                                        variant="outlined"
                                        size="small"
                                        startIcon={<EditIcon />}
                                        sx={{ mr: 1, borderColor: 'primary.main', color: 'primary.main' }}
                                        onClick={() => openEditModal(mechanic)}
                                    >
                                        Edit
                                    </Button>
                                    <Button
                                        variant="outlined"
                                        size="small"
                                        startIcon={<Trash2Icon />}
                                        color="error"
                                        onClick={() => handleDeleteClick(mechanic.id)}
                                    >
                                        Delete
                                    </Button>
                                </Box>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            )}

            <Dialog open={isModalOpen} onClose={() => setIsModalOpen(false)}>
                <DialogTitle>{currentMechanic ? "Edit Mechanic" : "Add New Mechanic"}</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Title"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                        sx={{ mb: 2 }}
                    />
                    <TextField
                        margin="dense"
                        label="Description"
                        type="text"
                        fullWidth
                        multiline
                        rows={4}
                        variant="outlined"
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setIsModalOpen(false)} color="inherit">Cancel</Button>
                    <Button onClick={handleSaveMechanic} variant="contained" color="primary">Save Mechanic</Button>
                </DialogActions>
            </Dialog>

            <AlertDialog
                open={alertOpen}
                title="Notification"
                message={alertMessage}
                onClose={() => setAlertOpen(false)}
            />
            <ConfirmationDialog
                open={confirmOpen}
                title="Confirm Deletion"
                message="Are you sure you want to delete this mechanic?"
                onConfirm={handleConfirmDelete}
                onCancel={() => setConfirmOpen(false)}
            />
        </Card>
    );
};

const Notifications = ({ appId, userId }) => {
    const [notifications, setNotifications] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [title, setTitle] = useState('');
    const [message, setMessage] = useState('');
    const [alertOpen, setAlertOpen] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');

    const fetchNotifications = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/notifications`);
            // if (!response.ok) throw new Error('Failed to fetch notifications');
            // const data = await response.json();
            const data = await apiService.getNotifications(appId); // Using mock apiService for demonstration
            setNotifications(data);
        } catch (err) {
            console.error("Error fetching notifications:", err);
            setError("Failed to load notifications. Please try again.");
            setNotifications([]);
        } finally {
            setLoading(false);
        }
    }, [appId]);

    useEffect(() => {
        fetchNotifications();
    }, [fetchNotifications]);

    const handleSendNotification = async () => {
        if (!title || !message) {
            setAlertMessage("Title and Message are required.");
            setAlertOpen(true);
            return;
        }

        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/notifications`, {
            //     method: 'POST',
            //     headers: { 'Content-Type': 'application/json' },
            //     body: JSON.stringify({ title, message, sentBy: userId }),
            // });
            // if (!response.ok) throw new Error('Failed to send notification');
            await apiService.sendNotification(appId, { title, message, sentBy: userId }); // Using mock apiService
            setIsModalOpen(false);
            setTitle('');
            setMessage('');
            setAlertMessage("Notification sent successfully!");
            setAlertOpen(true);
            fetchNotifications(); // Re-fetch data
        } catch (e) {
            console.error("Error sending notification:", e);
            setAlertMessage("Error sending notification. Please try again.");
            setAlertOpen(true);
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading notifications...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                Send Notifications
            </Typography>
            <Button variant="contained" startIcon={<PlusIcon />} onClick={() => setIsModalOpen(true)} sx={{ mb: 3, backgroundColor: 'secondary.main' }}>
                Compose New Notification
            </Button>

            {notifications.length === 0 ? (
                <Typography color="text.secondary">No notifications sent yet.</Typography>
            ) : (
                <Grid container spacing={3}>
                    {notifications.map(notif => (
                        <Grid item xs={12} md={6} key={notif.id}>
                            <Card variant="outlined" sx={{ p: 2 }}>
                                <CardContent>
                                    <Typography variant="h6" component="h3" sx={{ fontWeight: 'bold' }}>{notif.title}</Typography>
                                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>{notif.message}</Typography>
                                    <Typography variant="caption" color="text.disabled">
                                        Sent by: {notif.sentBy ? notif.sentBy.substring(0, 8) + '...' : 'N/A'} on {notif.sentAt ? new Date(notif.sentAt).toLocaleString() : 'N/A'}
                                    </Typography>
                                </CardContent>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            )}

            <Dialog open={isModalOpen} onClose={() => setIsModalOpen(false)}>
                <DialogTitle>Compose New Notification</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Notification Title"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                        sx={{ mb: 2 }}
                    />
                    <TextField
                        margin="dense"
                        label="Notification Message"
                        type="text"
                        fullWidth
                        multiline
                        rows={4}
                        variant="outlined"
                        value={message}
                        onChange={(e) => setMessage(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setIsModalOpen(false)} color="inherit">Cancel</Button>
                    <Button onClick={handleSendNotification} variant="contained" color="primary">Send Notification</Button>
                </DialogActions>
            </Dialog>

            <AlertDialog
                open={alertOpen}
                title="Notification"
                message={alertMessage}
                onClose={() => setAlertOpen(false)}
            />
        </Card>
    );
};

const FAQsManagement = ({ appId }) => {
    const [faqs, setFaqs] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [currentFaq, setCurrentFaq] = useState(null);
    const [question, setQuestion] = useState('');
    const [answer, setAnswer] = useState('');
    const [alertOpen, setAlertOpen] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');
    const [confirmOpen, setConfirmOpen] = useState(false);
    const [confirmId, setConfirmId] = useState(null);

    const fetchFaqs = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/faqs`);
            // if (!response.ok) throw new Error('Failed to fetch FAQs');
            // const data = await response.json();
            const data = await apiService.getFaqs(appId); // Using mock apiService for demonstration
            setFaqs(data);
        } catch (err) {
            console.error("Error fetching FAQs:", err);
            setError("Failed to load FAQs. Please try again.");
            setFaqs([]);
        } finally {
            setLoading(false);
        }
    }, [appId]);

    useEffect(() => {
        fetchFaqs();
    }, [fetchFaqs]);

    const openAddModal = () => {
        setCurrentFaq(null);
        setQuestion('');
        setAnswer('');
        setIsModalOpen(true);
    };

    const openEditModal = (faq) => {
        setCurrentFaq(faq);
        setQuestion(faq.question);
        setAnswer(faq.answer);
        setIsModalOpen(true);
    };

    const handleSaveFaq = async () => {
        if (!question || !answer) {
            setAlertMessage("Question and Answer are required.");
            setAlertOpen(true);
            return;
        }

        try {
            if (currentFaq) {
                // Placeholder API call for update
                // const response = await fetch(`/api/${appId}/faqs/${currentFaq.id}`, {
                //     method: 'PUT',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ question, answer }),
                // });
                // if (!response.ok) throw new Error('Failed to update FAQ');
                await apiService.updateFaq(appId, currentFaq.id, { question, answer }); // Using mock apiService
            } else {
                // Placeholder API call for add
                // const response = await fetch(`/api/${appId}/faqs`, {
                //     method: 'POST',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ question, answer }),
                // });
                // if (!response.ok) throw new Error('Failed to add FAQ');
                await apiService.addFaq(appId, { question, answer }); // Using mock apiService
            }
            setIsModalOpen(false);
            setAlertMessage("FAQ saved successfully!");
            setAlertOpen(true);
            fetchFaqs(); // Re-fetch data
        } catch (e) {
            console.error("Error saving FAQ:", e);
            setAlertMessage("Error saving FAQ. Please try again.");
            setAlertOpen(true);
        }
    };

    const handleDeleteClick = (id) => {
        setConfirmId(id);
        setConfirmOpen(true);
    };

    const handleConfirmDelete = async () => {
        setConfirmOpen(false);
        try {
            // Placeholder API call for delete
            // const response = await fetch(`/api/${appId}/faqs/${confirmId}`, {
            //     method: 'DELETE',
            // });
            // if (!response.ok) throw new Error('Failed to delete FAQ');
            await apiService.deleteFaq(appId, confirmId); // Using mock apiService
            setAlertMessage("FAQ deleted successfully!");
            setAlertOpen(true);
            fetchFaqs(); // Re-fetch data
        } catch (e) {
            console.error("Error deleting FAQ:", e);
            setAlertMessage("Error deleting FAQ. Please try again.");
            setAlertOpen(true);
        } finally {
            setConfirmId(null);
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading FAQs...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                FAQs Management
            </Typography>
            <Button variant="contained" startIcon={<PlusIcon />} onClick={openAddModal} sx={{ mb: 3, backgroundColor: 'secondary.main' }}>
                Add New FAQ
            </Button>

            {faqs.length === 0 ? (
                <Typography color="text.secondary">No FAQs defined yet.</Typography>
            ) : (
                <Grid container spacing={3}>
                    {faqs.map(faq => (
                        <Grid item xs={12} key={faq.id}>
                            <Card variant="outlined" sx={{ p: 2 }}>
                                <CardContent>
                                    <Typography variant="h6" component="h3" sx={{ fontWeight: 'bold' }}>{faq.question}</Typography>
                                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>{faq.answer}</Typography>
                                    <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<EditIcon />}
                                            sx={{ mr: 1, borderColor: 'primary.main', color: 'primary.main' }}
                                            onClick={() => openEditModal(faq)}
                                        >
                                            Edit
                                        </Button>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<Trash2Icon />}
                                            color="error"
                                            onClick={() => handleDeleteClick(faq.id)}
                                        >
                                            Delete
                                        </Button>
                                    </Box>
                                </CardContent>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            )}

            <Dialog open={isModalOpen} onClose={() => setIsModalOpen(false)}>
                <DialogTitle>{currentFaq ? "Edit FAQ" : "Add New FAQ"}</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Question"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={question}
                        onChange={(e) => setQuestion(e.target.value)}
                        sx={{ mb: 2 }}
                    />
                    <TextField
                        margin="dense"
                        label="Answer"
                        type="text"
                        fullWidth
                        multiline
                        rows={4}
                        variant="outlined"
                        value={answer}
                        onChange={(e) => setAnswer(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setIsModalOpen(false)} color="inherit">Cancel</Button>
                    <Button onClick={handleSaveFaq} variant="contained" color="primary">Save FAQ</Button>
                </DialogActions>
            </Dialog>

            <AlertDialog
                open={alertOpen}
                title="Notification"
                message={alertMessage}
                onClose={() => setAlertOpen(false)}
            />
            <ConfirmationDialog
                open={confirmOpen}
                title="Confirm Deletion"
                message="Are you sure you want to delete this FAQ?"
                onConfirm={handleConfirmDelete}
                onCancel={() => setConfirmOpen(false)}
            />
        </Card>
    );
};

const TipsManagement = ({ appId }) => {
    const [tips, setTips] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [currentTip, setCurrentTip] = useState(null);
    const [title, setTitle] = useState('');
    const [content, setContent] = useState('');
    const [alertOpen, setAlertOpen] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');
    const [confirmOpen, setConfirmOpen] = useState(false);
    const [confirmId, setConfirmId] = useState(null);

    const fetchTips = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/tips`);
            // if (!response.ok) throw new Error('Failed to fetch tips');
            // const data = await response.json();
            const data = await apiService.getTips(appId); // Using mock apiService for demonstration
            setTips(data);
        } catch (err) {
            console.error("Error fetching tips:", err);
            setError("Failed to load tips. Please try again.");
            setTips([]);
        } finally {
            setLoading(false);
        }
    }, [appId]);

    useEffect(() => {
        fetchTips();
    }, [fetchTips]);

    const openAddModal = () => {
        setCurrentTip(null);
        setTitle('');
        setContent('');
        setIsModalOpen(true);
    };

    const openEditModal = (tip) => {
        setCurrentTip(tip);
        setTitle(tip.title);
        setContent(tip.content);
        setIsModalOpen(true);
    };

    const handleSaveTip = async () => {
        if (!title || !content) {
            setAlertMessage("Title and Content are required.");
            setAlertOpen(true);
            return;
        }

        try {
            if (currentTip) {
                // Placeholder API call for update
                // const response = await fetch(`/api/${appId}/tips/${currentTip.id}`, {
                //     method: 'PUT',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ title, content }),
                // });
                // if (!response.ok) throw new Error('Failed to update tip');
                await apiService.updateTip(appId, currentTip.id, { title, content }); // Using mock apiService
            } else {
                // Placeholder API call for add
                // const response = await fetch(`/api/${appId}/tips`, {
                //     method: 'POST',
                //     headers: { 'Content-Type': 'application/json' },
                //     body: JSON.stringify({ title, content }),
                // });
                // if (!response.ok) throw new Error('Failed to add tip');
                await apiService.addTip(appId, { title, content }); // Using mock apiService
            }
            setIsModalOpen(false);
            setAlertMessage("Tip saved successfully!");
            setAlertOpen(true);
            fetchTips(); // Re-fetch data
        } catch (e) {
            console.error("Error saving tip:", e);
            setAlertMessage("Error saving tip. Please try again.");
            setAlertOpen(true);
        }
    };

    const handleDeleteClick = (id) => {
        setConfirmId(id);
        setConfirmOpen(true);
    };

    const handleConfirmDelete = async () => {
        setConfirmOpen(false);
        try {
            // Placeholder API call for delete
            // const response = await fetch(`/api/${appId}/tips/${confirmId}`, {
            //     method: 'DELETE',
            // });
            // if (!response.ok) throw new Error('Failed to delete tip');
            await apiService.deleteTip(appId, confirmId); // Using mock apiService
            setAlertMessage("Tip deleted successfully!");
            setAlertOpen(true);
            fetchTips(); // Re-fetch data
        } catch (e) {
            console.error("Error deleting tip:", e);
            setAlertMessage("Error deleting tip. Please try again.");
            setAlertOpen(true);
        } finally {
            setConfirmId(null);
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading tips...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                Tips Management
            </Typography>
            <Button variant="contained" startIcon={<PlusIcon />} onClick={openAddModal} sx={{ mb: 3, backgroundColor: 'secondary.main' }}>
                Add New Tip
            </Button>

            {tips.length === 0 ? (
                <Typography color="text.secondary">No tips defined yet.</Typography>
            ) : (
                <Grid container spacing={3}>
                    {tips.map(tip => (
                        <Grid item xs={12} key={tip.id}>
                            <Card variant="outlined" sx={{ p: 2 }}>
                                <CardContent>
                                    <Typography variant="h6" component="h3" sx={{ fontWeight: 'bold' }}>{tip.title}</Typography>
                                    <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>{tip.content}</Typography>
                                    <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<EditIcon />}
                                            sx={{ mr: 1, borderColor: 'primary.main', color: 'primary.main' }}
                                            onClick={() => openEditModal(tip)}
                                        >
                                            Edit
                                        </Button>
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<Trash2Icon />}
                                            color="error"
                                            onClick={() => handleDeleteClick(tip.id)}
                                        >
                                            Delete
                                        </Button>
                                    </Box>
                                </CardContent>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            )}

            <Dialog open={isModalOpen} onClose={() => setIsModalOpen(false)}>
                <DialogTitle>{currentTip ? "Edit Tip" : "Add New Tip"}</DialogTitle>
                <DialogContent>
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Tip Title"
                        type="text"
                        fullWidth
                        variant="outlined"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                        sx={{ mb: 2 }}
                    />
                    <TextField
                        margin="dense"
                        label="Tip Content"
                        type="text"
                        fullWidth
                        multiline
                        rows={4}
                        variant="outlined"
                        value={content}
                        onChange={(e) => setContent(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setIsModalOpen(false)} color="inherit">Cancel</Button>
                    <Button onClick={handleSaveTip} variant="contained" color="primary">Save Tip</Button>
                </DialogActions>
            </Dialog>

            <AlertDialog
                open={alertOpen}
                title="Notification"
                message={alertMessage}
                onClose={() => setAlertOpen(false)}
            />
            <ConfirmationDialog
                open={confirmOpen}
                title="Confirm Deletion"
                message="Are you sure you want to delete this Tip?"
                onConfirm={handleConfirmDelete}
                onCancel={() => setConfirmOpen(false)}
            />
        </Card>
    );
};

const UserMessages = ({ appId, userId }) => {
    const [messages, setMessages] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    const [isReplyModalOpen, setIsReplyModalOpen] = useState(false);
    const [currentMessage, setCurrentMessage] = useState(null);
    const [replyContent, setReplyContent] = useState('');
    const [alertOpen, setAlertOpen] = useState(false);
    const [alertMessage, setAlertMessage] = useState('');
    const [confirmOpen, setConfirmOpen] = useState(false);
    const [confirmId, setConfirmId] = useState(null);

    const fetchMessages = useCallback(async () => {
        setLoading(true);
        setError(null);
        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/user-messages`);
            // if (!response.ok) throw new Error('Failed to fetch messages');
            // const data = await response.json();
            const data = await apiService.getUserMessages(appId); // Using mock apiService for demonstration
            setMessages(data);
        } catch (err) {
            console.error("Error fetching messages:", err);
            setError("Failed to load messages. Please try again.");
            setMessages([]);
        } finally {
            setLoading(false);
        }
    }, [appId]);

    useEffect(() => {
        fetchMessages();
    }, [fetchMessages]);

    const openReplyModal = (message) => {
        setCurrentMessage(message);
        setReplyContent(message.reply || '');
        setIsReplyModalOpen(true);
    };

    const handleSendReply = async () => {
        if (!replyContent) {
            setAlertMessage("Reply content cannot be empty.");
            setAlertOpen(true);
            return;
        }
        if (!currentMessage) return;

        try {
            // Placeholder API call
            // const response = await fetch(`/api/${appId}/user-messages/${currentMessage.id}/reply`, {
            //     method: 'POST',
            //     headers: { 'Content-Type': 'application/json' },
            //     body: JSON.stringify({ reply: replyContent, repliedBy: userId }),
            // });
            // if (!response.ok) throw new Error('Failed to send reply');
            await apiService.replyToMessage(appId, currentMessage.id, { reply: replyContent, repliedBy: userId }); // Using mock apiService
            setIsReplyModalOpen(false);
            setReplyContent('');
            setAlertMessage("Reply sent successfully!");
            setAlertOpen(true);
            fetchMessages(); // Re-fetch data
        } catch (e) {
            console.error("Error sending reply:", e);
            setAlertMessage("Error sending reply. Please try again.");
            setAlertOpen(true);
        }
    };

    const handleDeleteClick = (id) => {
        setConfirmId(id);
        setConfirmOpen(true);
    };

    const handleConfirmDelete = async () => {
        setConfirmOpen(false);
        try {
            // Placeholder API call for delete
            // const response = await fetch(`/api/${appId}/user-messages/${confirmId}`, {
            //     method: 'DELETE',
            // });
            // if (!response.ok) throw new Error('Failed to delete message');
            await apiService.deleteMessage(appId, confirmId); // Using mock apiService
            setAlertMessage("Message deleted successfully!");
            setAlertOpen(true);
            fetchMessages(); // Re-fetch data
        } catch (e) {
            console.error("Error deleting message:", e);
            setAlertMessage("Error deleting message. Please try again.");
            setAlertOpen(true);
        } finally {
            setConfirmId(null);
        }
    };

    if (loading) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography>Loading messages...</Typography></Box>;
    if (error) return <Box sx={{ display: 'flex', justifyContent: 'center', p: 3 }}><Typography color="error">{error}</Typography></Box>;

    return (
        <Card sx={{ p: 3, m: 3 }}>
            <Typography variant="h5" component="h2" gutterBottom sx={{ fontWeight: 'semibold', borderBottom: '1px solid #e5e7eb', pb: 1 }}>
                User Messages
            </Typography>
            {messages.length === 0 ? (
                <Typography color="text.secondary">No messages from users.</Typography>
            ) : (
                <Grid container spacing={3}>
                    {messages.map(message => (
                        <Grid item xs={12} key={message.id}>
                            <Card variant="outlined" sx={{ p: 2 }}>
                                <CardContent>
                                    <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 1 }}>
                                        <Typography variant="h6" component="h3" sx={{ fontWeight: 'bold' }}>
                                            From: {message.senderId ? message.senderId.substring(0, 8) + '...' : 'Anonymous'}
                                        </Typography>
                                        <Chip
                                            label={message.status || 'New'}
                                            color={message.status === 'replied' ? 'success' : 'warning'}
                                            size="small"
                                        />
                                    </Box>
                                    <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>{message.content}</Typography>
                                    <Typography variant="caption" color="text.disabled">
                                        Received: {message.timestamp ? new Date(message.timestamp).toLocaleString() : 'N/A'}
                                    </Typography>
                                    {message.reply && (
                                        <Box sx={{ mt: 2, p: 2, backgroundColor: 'primary.light', borderRadius: 2, borderLeft: '4px solid', borderColor: 'primary.main' }}>
                                            <Typography variant="subtitle2" sx={{ fontWeight: 'medium', color: 'primary.dark' }}>Admin Reply:</Typography>
                                            <Typography variant="body2" color="text.primary">{message.reply}</Typography>
                                            <Typography variant="caption" color="text.disabled" sx={{ mt: 0.5 }}>
                                                Replied by: {message.repliedBy ? message.repliedBy.substring(0, 8) + '...' : 'N/A'} on {message.repliedAt ? new Date(message.repliedAt).toLocaleString() : 'N/A'}
                                            </Typography>
                                        </Box>
                                    )}
                                    <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 2 }}>
                                        {!message.reply && (
                                            <Button
                                                variant="outlined"
                                                size="small"
                                                startIcon={<CheckIcon />}
                                                sx={{ mr: 1, borderColor: 'info.main', color: 'info.main' }}
                                                onClick={() => openReplyModal(message)}
                                            >
                                                Reply
                                            </Button>
                                        )}
                                        <Button
                                            variant="outlined"
                                            size="small"
                                            startIcon={<Trash2Icon />}
                                            color="error"
                                            onClick={() => handleDeleteClick(message.id)}
                                        >
                                            Delete
                                        </Button>
                                    </Box>
                                </CardContent>
                            </Card>
                        </Grid>
                    ))}
                </Grid>
            )}

            <Dialog open={isReplyModalOpen} onClose={() => setIsReplyModalOpen(false)}>
                <DialogTitle>Reply to Message</DialogTitle>
                <DialogContent>
                    {currentMessage && (
                        <Card variant="outlined" sx={{ mb: 2, p: 2, backgroundColor: '#f9fafb' }}>
                            <Typography variant="subtitle1" sx={{ fontWeight: 'semibold' }}>Original Message from {currentMessage.senderId ? currentMessage.senderId.substring(0, 8) + '...' : 'Anonymous'}:</Typography>
                            <Typography variant="body2" sx={{ fontStyle: 'italic' }}>{currentMessage.content}</Typography>
                        </Card>
                    )}
                    <TextField
                        autoFocus
                        margin="dense"
                        label="Your Reply"
                        type="text"
                        fullWidth
                        multiline
                        rows={6}
                        variant="outlined"
                        value={replyContent}
                        onChange={(e) => setReplyContent(e.target.value)}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={() => setIsReplyModalOpen(false)} color="inherit">Cancel</Button>
                    <Button onClick={handleSendReply} variant="contained" color="primary">Send Reply</Button>
                </DialogActions>
            </Dialog>

            <AlertDialog
                open={alertOpen}
                title="Notification"
                message={alertMessage}
                onClose={() => setAlertOpen(false)}
            />
            <ConfirmationDialog
                open={confirmOpen}
                title="Confirm Deletion"
                message="Are you sure you want to delete this message?"
                onConfirm={handleConfirmDelete}
                onCancel={() => setConfirmOpen(false)}
            />
        </Card>
    );
};


// --- Main App Component ---
const App = () => {
    const [currentPage, setCurrentPage] = useState('dashboard');
    // userId and appId are mock/placeholder values for frontend demonstration
    const [userId] = useState('admin_mock_user_id');
    const [appId] = useState(typeof __app_id !== 'undefined' ? __app_id : 'default-app-id');

    // Navbar component
    const Navbar = () => (
        <AppBar position="static" sx={{ backgroundColor: '#1f2937', boxShadow: '0px 4px 6px rgba(0, 0, 0, 0.1)' }}>
            <Toolbar sx={{ flexWrap: 'wrap', justifyContent: 'space-between' }}>
                <Typography variant="h5" component="div" sx={{ fontWeight: 'bold', color: '#818cf8', mr: 2, mb: { xs: 1, md: 0 } }}>
                    Admin Panel
                </Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center', flexGrow: 1 }}>
                    <NavItem icon={<HomeIcon />} label="Dashboard" page="dashboard" />
                    <NavItem icon={<UsersIcon />} label="Users" page="users" />
                    <NavItem icon={<ActivityIcon />} label="Activity" page="activity" />
                    <NavItem icon={<SettingsIcon />} label="Mechanics" page="mechanics" />
                    <NavItem icon={<BellIcon />} label="Notifications" page="notifications" />
                    <NavItem icon={<HelpCircleIcon />} label="FAQs" page="faqs" />
                    <NavItem icon={<LightbulbIcon />} label="Tips" page="tips" />
                    <NavItem icon={<MessageSquareIcon />} label="Messages" page="messages" />
                </Box>
            </Toolbar>
        </AppBar>
    );

    const NavItem = ({ icon, label, page }) => (
        <Button
            color="inherit"
            onClick={() => setCurrentPage(page)}
            sx={{
                mx: 1,
                py: 1,
                borderRadius: 2,
                fontWeight: 'medium',
                backgroundColor: currentPage === page ? '#4338ca' : 'transparent', // Indigo 700
                '&:hover': {
                    backgroundColor: currentPage === page ? '#4338ca' : '#374151', // Gray 700
                },
            }}
            startIcon={icon}
        >
            {label}
        </Button>
    );

    // Main content rendering based on currentPage
    const renderPage = useCallback(() => {
        const commonProps = { userId, appId };

        switch (currentPage) {
            case 'dashboard':
                return <Dashboard {...commonProps} />;
            case 'users':
                return <UserManagement {...commonProps} />;
            case 'activity':
                return <ActivityLogs {...commonProps} />;
            case 'mechanics':
                return <MechanicsManagement {...commonProps} />;
            case 'notifications':
                return <Notifications {...commonProps} />;
            case 'faqs':
                return <FAQsManagement {...commonProps} />;
            case 'tips':
                return <TipsManagement {...commonProps} />;
            case 'messages':
                return <UserMessages {...commonProps} />;
            default:
                return <Dashboard {...commonProps} />;
        }
    }, [currentPage, userId, appId]);

    return (
        <ThemeProvider theme={theme}>
            <Box sx={{ minHeight: '100vh', backgroundColor: '#f3f4f6' }}> {/* Gray 100 */}
                <Navbar />
                <Container maxWidth="xl" sx={{ py: 3 }}>
                    {renderPage()}
                </Container>
            </Box>
        </ThemeProvider>
    );
};

export default App;
