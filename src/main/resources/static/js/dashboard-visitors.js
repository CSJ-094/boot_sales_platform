const canvasV = document.getElementById('visitorChart');
if (!canvasV) {
    console.error('visitorChart 캔버스를 찾을 수 없습니다.');
} else {
    const ctxVisitor = canvasV.getContext('2d');
    let visitorChart = null;
    let currentVisitorData = [];

    function updateVisitorTrend(period, data) {
        const labelEl = document.getElementById('visitorTrendLabel');
        const valueEl = document.getElementById('visitorTrendValue');
        if (!labelEl || !valueEl) return;

        if (period === 'day') labelEl.textContent = '전일 대비';
        else if (period === 'week') labelEl.textContent = '전주 대비';
        else labelEl.textContent = '전월 대비';

        if (!data || data.length < 2) {
            valueEl.textContent = '-';
            valueEl.className = 'dash-trend-value neutral';
            return;
        }

        const vals = data.map(d => d.visitorCount);
        const last = vals[vals.length - 1];
        const prev = vals[vals.length - 2];

        if (prev === 0) {
            valueEl.textContent = '-';
            valueEl.className = 'dash-trend-value neutral';
            return;
        }

        const diffPercent = (last - prev) / prev * 100;
        const formatted = `${diffPercent > 0 ? '+' : ''}${diffPercent.toFixed(1)}%`;
        valueEl.textContent = formatted;

        if (diffPercent > 0) valueEl.className = 'dash-trend-value up';
        else if (diffPercent < 0) valueEl.className = 'dash-trend-value down';
        else valueEl.className = 'dash-trend-value neutral';
    }

    function loadVisitors(period) {
        fetch(ctxPath + '/seller/dashboard/visitors?period=' + period)
            .then(res => res.json())
            .then(data => {
				console.log('visitors api data:', data); // 콘솔
                currentVisitorData = data;

                const labels = data.map(d => d.label);
                const vals = data.map(d => d.visitorCount);

                if (visitorChart) visitorChart.destroy();

                visitorChart = new Chart(ctxVisitor, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '방문자 수',
                            data: vals,
                            tension: 0.3,
                            fill: false
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: { display: false }
                        },
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                });

                updateVisitorTrend(period, data);
            })
            .catch(err => console.error('방문자 그래프 로딩 실패', err));
    }

    document.querySelectorAll('.visitor-tab').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.visitor-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            loadVisitors(this.dataset.period);
        });
    });

    // 기본 로드
    loadVisitors('day');
}
