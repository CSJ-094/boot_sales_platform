document.addEventListener('DOMContentLoaded', function () {
    // ===== 주문 필터 =====
    const orderFilterBtns = document.querySelectorAll('.dash-recent-orders .order-filter-btn');
    const orderRows = document.querySelectorAll('.dash-recent-orders tbody tr');

    if (orderFilterBtns.length && orderRows.length) {
        orderFilterBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const status = btn.getAttribute('data-status');

                // 버튼 active 토글
                orderFilterBtns.forEach(b => b.classList.remove('is-active'));
                btn.classList.add('is-active');

                // 행 필터링
                orderRows.forEach(row => {
                    const rowStatus = row.getAttribute('data-status');
                    if (status === 'ALL' || status === rowStatus) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });
    }

    // ===== 문의 필터 =====
    const qnaFilterBtns = document.querySelectorAll('.dash-recent-qna .qna-filter-btn');
    const qnaRows = document.querySelectorAll('.dash-recent-qna tbody tr');

    if (qnaFilterBtns.length && qnaRows.length) {
        qnaFilterBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const status = btn.getAttribute('data-status');

                qnaFilterBtns.forEach(b => b.classList.remove('is-active'));
                btn.classList.add('is-active');

                qnaRows.forEach(row => {
                    const rowStatus = row.getAttribute('data-status');
                    if (status === 'ALL' || status === rowStatus) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
        });
    }
});
