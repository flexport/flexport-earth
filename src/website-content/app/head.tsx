type HeadParams = {
    slug: string
}

export default async function Head(params: HeadParams) {
    let title = "Flexport Earth";

    if (params.slug) {
        title += `: ${params.slug}`;
    }

    return (
      <>
        <title>{title}</title>
        <meta name="description" content="Facts of global trade" />
        <link rel="icon" href="/favicon.ico" />
      </>
    )
}
