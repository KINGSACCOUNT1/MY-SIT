from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.core.paginator import Paginator
from .models import Notification


@login_required
def notification_list(request):
    """List all notifications for the current user"""
    notifications = Notification.objects.filter(user=request.user).order_by('-created_at')
    
    # Filter by read status
    filter_status = request.GET.get('status', 'all')
    if filter_status == 'unread':
        notifications = notifications.filter(is_read=False)
    elif filter_status == 'read':
        notifications = notifications.filter(is_read=True)
    
    # Pagination
    paginator = Paginator(notifications, 20)
    page = request.GET.get('page', 1)
    notifications_page = paginator.get_page(page)
    
    # Count unread
    unread_count = Notification.objects.filter(user=request.user, is_read=False).count()
    
    context = {
        'notifications': notifications_page,
        'unread_count': unread_count,
        'filter_status': filter_status,
    }
    
    return render(request, 'notifications/list.html', context)


@login_required
@require_POST
def mark_as_read(request, notification_id):
    """Mark a single notification as read"""
    notification = get_object_or_404(Notification, id=notification_id, user=request.user)
    notification.mark_as_read()
    
    return JsonResponse({'success': True, 'notification_id': notification_id})


@login_required
@require_POST
def mark_all_as_read(request):
    """Mark all notifications as read"""
    Notification.mark_all_as_read(request.user)
    
    return JsonResponse({'success': True})


@login_required
@require_POST
def delete_notification(request, notification_id):
    """Delete a notification"""
    notification = get_object_or_404(Notification, id=notification_id, user=request.user)
    notification.delete()
    
    return JsonResponse({'success': True, 'notification_id': notification_id})


@login_required
def check_new_notifications(request):
    """Check for new unread notifications"""
    count = Notification.objects.filter(user=request.user, is_read=False).count()

    # Store last check in session to only trigger alert on *new* arrivals
    last_unread = request.session.get('last_unread_count', 0)
    new_notifications = count > last_unread

    request.session['last_unread_count'] = count

    return JsonResponse({'new_notifications': new_notifications, 'count': count})


@login_required
def unread_count(request):
    """Get unread notification count"""
    count = Notification.objects.filter(user=request.user, is_read=False).count()
    return JsonResponse({'count': count})


@login_required
def recent_notifications(request):
    """Get recent notifications (for dropdown)"""
    notifications = Notification.objects.filter(
        user=request.user
    ).order_by('-created_at')[:5]

    data = [{
        'id': n.id,
        'title': n.title,
        'message': n.message[:100],
        'type': n.notification_type,
        'is_read': n.is_read,
        'action_url': n.action_url,
        'created_at': n.created_at.isoformat(),
    } for n in notifications]

    unread_count = Notification.objects.filter(user=request.user, is_read=False).count()

    return JsonResponse({
        'notifications': data,
        'unread_count': unread_count
    })