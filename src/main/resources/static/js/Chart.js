// /js/dashboard-chart.js
const canvas = document.getElementById('salesChart');
if (!canvas) {
    console.error('salesChart 캔버스를 찾을 수 없습니다.');
} else {
    const ctxSales = canvas.getContext('2d');
    let salesChart = null;
    let currentSalesData = []; // 원본 데이터 저장용

    function updateTrend(period, data) {
        const labelEl = document.getElementById('salesTrendLabel');
        const valueEl = document.getElementById('salesTrendValue');
        if (!labelEl || !valueEl) return;

        // 탭에 따라 라벨 텍스트 변경
        if (period === 'day') {
            labelEl.textContent = '전일 대비';
        } else if (period === 'week') {
            labelEl.textContent = '전주 대비';
        } else {
            labelEl.textContent = '전월 대비';
        }

        if (!data || data.length < 2) {
            valueEl.textContent = '-';
            valueEl.className = 'dash-trend-value neutral';
            return;
        }

        const amounts = data.map(d => d.salesAmount);
        const last = amounts[amounts.length - 1];
        const prev = amounts[amounts.length - 2];

        if (prev === 0) {
            valueEl.textContent = '-';
            valueEl.className = 'dash-trend-value neutral';
            return;
        }

        const diffPercent = (last - prev) / prev * 100;
        const formatted = `${diffPercent > 0 ? '+' : ''}${diffPercent.toFixed(1)}%`;

        valueEl.textContent = formatted;

        if (diffPercent > 0) {
            valueEl.className = 'dash-trend-value up';
        } else if (diffPercent < 0) {
            valueEl.className = 'dash-trend-value down';
        } else {
            valueEl.className = 'dash-trend-value neutral';
        }
    }

    function loadSales(period) {
        fetch(ctxPath + '/seller/dashboard/sales?period=' + period)
            .then(res => res.json())
            .then(data => {
                currentSalesData = data; // 원본 그대로 저장

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
                            legend: { display: false },
                            tooltip: {
                                callbacks: {
                                    // 툴팁 제목 = 날짜/라벨
                                    title: function (items) {
                                        if (!items.length) return '';
                                        return items[0].label;
                                    },
                                    // 툴팁 내용 여러 줄
                                    label: function (context) {
                                        const idx = context.dataIndex;
                                        const point = currentSalesData[idx];
                                        if (!point) return '';

                                        const amount = point.salesAmount || 0;
                                        const count = point.orderCount || 0;
                                        const avg = count > 0 ? Math.round(amount / count) : 0;

                                        const lines = [];
                                        lines.push(`매출액: ${amount.toLocaleString()}원`);
                                        lines.push(`주문 수: ${count}건`);
                                        lines.push(`평균 주문금액: ${avg.toLocaleString()}원/건`);
                                        return lines;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });

                // 그래프 그린 뒤 증감 라벨 갱신
                updateTrend(period, data);
            })
            .catch(err => {
                console.error('매출 그래프 로딩 실패', err);
            });
    }

    // 탭 이벤트 그대로 유지
    document.querySelectorAll('.sales-tab').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.sales-tab').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            loadSales(this.dataset.period);
        });
    });

    // 기본: 일별
    loadSales('day');
}
