// /js/dashboard-chart.js
const canvas = document.getElementById('salesChart');
if (!canvas) {
    console.error('salesChart 캔버스를 찾을 수 없습니다.');
} else {
    const ctxSales = canvas.getContext('2d');
    let salesChart = null;

    function loadSales(period) {
        fetch(ctxPath + '/seller/dashboard/sales?period=' + period)
            .then(res => res.json())
            .then(data => {
                const labels = data.map(d => d.label);
                const amounts = data.map(d => d.salesAmount);

                if (salesChart) {
                    salesChart.destroy();
                }

                salesChart = new Chart(ctxSales, {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: '매출액',
                            data: amounts,
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
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            })
            .catch(err => {
                console.error('매출 그래프 로딩 실패', err);
            });
    }

    // 탭 클릭 이벤트
    document.querySelectorAll('.sales-tab').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.sales-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            loadSales(this.dataset.period);
        });
    });

    // 기본: 일별 로딩
    loadSales('day');
}