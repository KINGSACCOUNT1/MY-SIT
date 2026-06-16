// Simple notification sound
const notificationSound = new Audio('/static/sounds/notification.mp3');

function checkNotifications() {
    fetch('/notifications/check/')
        .then(response => response.json())
        .then(data => {
            if (data.new_notifications) {
                // Play sound
                notificationSound.play().catch(e => console.log('Autoplay prevented'));
                
                // Optional: Alert or visual update
                console.log('New notification received!');
            }
        });
}

// Poll every 30 seconds
setInterval(checkNotifications, 30000);
