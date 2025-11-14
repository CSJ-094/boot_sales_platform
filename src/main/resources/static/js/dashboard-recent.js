document.addEventListener('DOMContentLoaded', function () {
    const filterBtns = document.querySelectorAll('.dash-filter .filter-btn');
    const rows = document.querySelectorAll('.dash-recent tbody tr');

    // 버튼은 있어야 하니까 이것만 체크
    if (!filterBtns.length) return;

    filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const status = btn.getAttribute('data-status');

            // 버튼 활성화 토글
            filterBtns.forEach(b => b.classList.remove('is-active'));
            btn.classList.add('is-active');

            // 행 필터링 (행이 0개면 그냥 아무 일 안 일어남)
            rows.forEach(row => {
                const rowStatus = row.getAttribute('data-status');
                if (status === 'ALL' || status === rowStatus) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    });
});
