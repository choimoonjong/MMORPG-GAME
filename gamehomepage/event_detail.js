document.addEventListener('DOMContentLoaded', () => {
    const id = new URLSearchParams(location.search).get('id');

    if (!id) {
        document.getElementById('page-heading').textContent =
            "이벤트를 찾을 수 없습니다.";
        return;
    }

    fetch(`/api/events/${id}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('데이터 로딩 실패');
            }
            return response.json();
        })
        .then(ev => {

            document.getElementById('ev-title').textContent = ev.title;

            const badge = document.getElementById('ev-badge');

            const isOngoing = ev.status === 'ongoing';

            badge.textContent = isOngoing ? '진행중' : '종료';
            badge.className = `ev-badge ${ev.status}`;

            const date = ev.created_at
                ? new Date(ev.created_at).toLocaleString('ko-KR')
                : '';

            document.getElementById('ev-meta').innerHTML = `
                <span>작성자 ${ev.author || 'GM'}</span>
                <span>등록 ${date}</span>
            `;

            const imageUrl =
                EVENT_IMAGE_MAP[ev.id] || DEFAULT_EVENT_IMAGE;

            const heroImg = document.getElementById('ev-hero-img');

            if (heroImg) {
                heroImg.src = imageUrl;
            }

            const content = document.getElementById('ev-content');
            content.innerHTML = ev.content || '';

            document
                .getElementById('btn-copy')
                ?.addEventListener('click', () => {

                    navigator.clipboard.writeText(location.href)
                        .then(() =>
                            alert("이벤트 링크가 복사되었습니다.")
                        )
                        .catch(() =>
                            alert("링크 복사에 실패했습니다.")
                        );
                });
        })
        .catch(error => {
            console.error("이벤트 상세 정보 로딩 실패:", error);

            document.getElementById('page-heading').textContent =
                "이벤트를 불러오는 데 실패했습니다.";

            document.getElementById('ev-content').innerHTML = '';
        });
});